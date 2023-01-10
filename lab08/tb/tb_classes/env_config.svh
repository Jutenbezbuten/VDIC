class env_config;

//------------------------------------------------------------------------------
// configuration variables
//------------------------------------------------------------------------------

    virtual vdic_dut_2022_bfm class_bfm;
    virtual vdic_dut_2022_bfm module_bfm;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(virtual vdic_dut_2022_bfm class_bfm, virtual vdic_dut_2022_bfm module_bfm);
        this.class_bfm  = class_bfm;
        this.module_bfm = module_bfm;
    endfunction : new

endclass : env_config
