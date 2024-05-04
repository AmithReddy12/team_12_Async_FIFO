`include "transcation.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;

  virtual interface_fifo in;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  transcation trans;  
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
    trans = new();
    endtask

  task pre_test();
   drv.reset();
  endtask

  
   task write();
    fork
    gen.write();
    mon.write();
    scb.write();
    drv.write(trans);
    drv.read(trans);
    join_any
   endtask


   task post_test();
    $display("entered this post_test");
    wait(gen_end.triggered);
    wait(gen.repeat_gen == drv.no_trans);
    wait(drv.no_trans == 9'h100);
   endtask


   task run();
    pre_test();
    write();
    post_test();
    $finish;
  endtask


endclass