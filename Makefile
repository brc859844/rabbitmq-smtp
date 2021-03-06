VSN=3.1.5
PACKAGE=rabbitmq-smtp-$(VSN)
DIST_DIR=dist
EBIN_DIR=ebin
INCLUDE_DIRS=
DEPS_DIR=deps
DEPS ?= 
DEPS_EZ=$(foreach DEP, $(DEPS), $(DEPS_DIR)/$(DEP).ez)
RABBITMQ_HOME ?= .

all: compile package

clean:
	rm -rf $(DIST_DIR)
	rm -rf $(EBIN_DIR)

distclean: clean
	rm -rf $(DEPS_DIR)

package: compile $(DEPS_EZ)
	rm -f $(DIST_DIR)/$(PACKAGE).ez
	mkdir -p $(DIST_DIR)/$(PACKAGE)
	cp -r $(EBIN_DIR) $(DIST_DIR)/$(PACKAGE)
	$(foreach EXTRA_DIR, $(INCLUDE_DIRS), cp -r $(EXTRA_DIR) $(DIST_DIR)/$(PACKAGE);)
	(cd $(DIST_DIR); zip -r $(PACKAGE).ez $(PACKAGE))

install: package
	$(foreach DEP, $(DEPS_EZ), cp $(DEP) $(RABBITMQ_HOME)/plugins;)
	cp $(DIST_DIR)/$(PACKAGE).ez $(RABBITMQ_HOME)/plugins

$(DEPS_DIR):
	./rebar get-deps

$(DEPS_EZ): 
	cd $(DEPS_DIR); $(foreach DEP, $(DEPS), zip -r $(DEP).ez $(DEP);)

compile: $(DEPS_DIR)
	./rebar compile
