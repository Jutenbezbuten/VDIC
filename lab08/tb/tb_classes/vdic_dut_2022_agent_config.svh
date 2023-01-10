class vdic_dut_2022_agent_config;

//------------------------------------------------------------------------------
// configuration variables
//------------------------------------------------------------------------------

   virtual vdic_dut_2022_bfm bfm;
   protected  uvm_active_passive_enum     is_active;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

   function new (virtual vdic_dut_2022_bfm bfm, uvm_active_passive_enum
		 is_active);
      this.bfm = bfm;
      this.is_active = is_active;
   endfunction : new

//------------------------------------------------------------------------------
// is_active access function
//------------------------------------------------------------------------------

   function uvm_active_passive_enum get_is_active();
      return is_active;
   endfunction : get_is_active
   
endclass : vdic_dut_2022_agent_config

