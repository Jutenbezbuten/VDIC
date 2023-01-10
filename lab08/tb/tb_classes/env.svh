class env extends uvm_env;
    `uvm_component_utils(env)

    vdic_dut_2022_agent class_vdic_dut_agent_h;
    vdic_dut_2022_agent module_vdic_dut_agent_h;
	
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new


    function void build_phase(uvm_phase phase);

        // declare configuration object handlers
        env_config env_config_h;
         vdic_dut_2022_agent_config class_agent_config_h;
         vdic_dut_2022_agent_config module_agent_config_h;

        // get the env_config with two BFM's included
        if(!uvm_config_db #(env_config)::get(this, "","config", env_config_h))
            `uvm_fatal("ENV", "Failed to get config object");

        // create configs for the agents
        class_agent_config_h   = new(.bfm(env_config_h.class_bfm), .is_active(UVM_ACTIVE));
        
        // for the second DUT we provide external stimulus, the agent does not generate it
        module_agent_config_h  = new(.bfm(env_config_h.module_bfm), .is_active(UVM_PASSIVE));

        // store the agent configs in the UMV database
        // important: restricted access by the hierarchical name, the second argument must
        //            match the agent handler name
        uvm_config_db #(vdic_dut_2022_agent_config)::set(this, "class_vdic_dut_agent_h*",
            "config", class_agent_config_h);
        uvm_config_db #(vdic_dut_2022_agent_config)::set(this, "module_vdic_dut_agent_h*",
            "config", module_agent_config_h);

        // create the agents
        class_vdic_dut_agent_h  = vdic_dut_2022_agent::type_id::create("class_vdic_dut_agent_h",this);
        module_vdic_dut_agent_h = vdic_dut_2022_agent::type_id::create("module_vdic_dut_agent_h",this);

    endfunction : build_phase

    //tester tester_h;
    //coverage coverage_h;
    //scoreboard scoreboard_h;
    //driver driver_h;
    //command_monitor command_monitor_h;
    //result_monitor result_monitor_h;
	//uvm_tlm_fifo #(command_transaction) command_f;
	//
	//function void build_phase(uvm_phase phase);
	//	command_f         = new("command_f", this, 10);
    //    tester_h     = tester::type_id::create("tester_h",this);
	//	driver_h          = driver::type_id::create("drive_h",this);
    //    coverage_h   = coverage::type_id::create ("coverage_h",this);
    //    scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
	//	command_monitor_h = command_monitor::type_id::create("command_monitor_h",this);
    //    result_monitor_h  = result_monitor::type_id::create("result_monitor_h",this);
	//endfunction : build_phase
	//
	//function void connect_phase(uvm_phase phase);
    //    driver_h.command_port.connect(command_f.get_export);
    //    tester_h.command_port.connect(command_f.put_export);
    //    result_monitor_h.ap.connect(scoreboard_h.analysis_export);
    //    command_monitor_h.ap.connect(scoreboard_h.din_msg.analysis_export);
    //    command_monitor_h.ap.connect(coverage_h.analysis_export);
    //endfunction : connect_phase
    //
    //function new (string name, uvm_component parent);
    //    super.new(name,parent);
    //endfunction : new
endclass
