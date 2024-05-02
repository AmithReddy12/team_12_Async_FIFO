`include "transcation.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class environment;

  virtual interface_fifo in;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  Cov_class cov;
  
  mailbox gtd;
  mailbox mts;

  
  event gen_end;

  function new(virtual interface_fifo in);

    this.in = in;
   endfunction
    
    task build();
    gtd = new();
    mts = new();
    gen = new(gtd,gen_end);
    drv = new(in,gtd);
    mon = new(in,mts);
    scb = new(in,mts);
    cov = new(in);
    endtask

  task pre_test();
   drv.reset();
  endtask

  
   task write();
    fork
    gen.write();
    drv.write_read();
    mon.write();
    scb.write();
    cov.execute();
    join_any
   endtask


   task post_test();
    $display("entered this post_test");
    wait(gen_end.triggered);
    wait(gen.repeat_gen == drv.no_trans);
    wait(drv.no_trans == scb.no_trans);
   endtask


   task run();
    pre_test();
    write();
    post_test();
    $finish;
  endtask


endclass