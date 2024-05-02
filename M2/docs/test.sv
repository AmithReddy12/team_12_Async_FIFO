`include "env.sv"

program test(interface_fifo in);

  environment env;
  
  initial begin
    env = new(in); 
    env.build(); 
    env.gen.repeat_count = 1;
    env.run();
  end
  
endprogram