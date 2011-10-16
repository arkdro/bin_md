INCLUDE_DIR = include
INCLUDE_DIR += ../../..
INCLUDE_DIR += ../proper/include
INCLUDES = $(INCLUDE_DIR:%=-I%)
SRC_DIR = src
EBIN_DIR := ebin
#ERLC_OPTS = +debug_info -DPROPER -pa ../proper/ebin
ERLC_OPTS = +debug_info -pa ../proper/ebin
ERLC := erlc $(ERLC_OPTS)

all: $(EBIN_DIR)
	$(ERLC) -W $(INCLUDES) -o $(EBIN_DIR) $(SRC_DIR)/*.erl
	
clean:
	@rm -f $(EBIN_DIR)/*

$(EBIN_DIR) :
	(test -d $(EBIN_DIR) || mkdir -p $(EBIN_DIR))

