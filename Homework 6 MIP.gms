$onText
CEE 6410
Homework 5

Matthew Fugal
fugalmatt@gmail.com
October 8, 2024
$offText

SETS
    t /1*2/
    src /low, high, pump/;

PARAMETERS
    inflow(t)
         /1 600, 2 200/
    groundwater(t)
        /1 364, 2 364/
    irr_profit(t)
         /1 300, 2 100/
    CapCost(src) capital cost ($ to build)
         /low 6000, high 10000, pump 8000/
   maxcapacity(src) Maximum capacity of source when built (ac-ft per year)
          /low 300, high 700, pump 400.4/
   reservoircapacity(src)
          /low 300, high 700, pump 0/;
    
VARIABLES
    storage(t)         
    reservoir_use(t) 
    reservoir_release(t)  
    pump_use(t)      
    total_profit
    I(src) binary decision to build or do prject from source src (1=yes 0=no)
    TCOST  total capital and operating costs of supply actions ($);
    
Scalar
    initial_storage /0/;

POSITIVE VARIABLES storage, reservoir_use, reservoir_release, pump_use;

Binary Variable I;

EQUATIONS
    damlimit
    water_balance(t)
    reservoir_capacity(t)  
    pump_capacity(t)         
    pump_limit(t)      
    profit;

damlimit..
    I("low")+I("high") =L= 1;

water_balance(t).. 
    storage(t) =E= storage(t-1)$(ord(t) > 1) + inflow(t) - reservoir_use(t) - reservoir_release(t) + initial_storage$(ord(t)=1);

reservoir_capacity(t).. 
    storage(t) + reservoir_use(t) + reservoir_release(t) =L= sum(src, reservoircapacity(src) * I(src));

pump_capacity(t)..
    pump_use(t) =L= maxcapacity("pump") * I("pump");

pump_limit(t).. 
    pump_use(t) =L= reservoir_release(t) + groundwater(t);

profit..
    total_profit =E= SUM(t, reservoir_use(t) * irr_profit(t) + pump_use(t) * (irr_profit(t) - 20)) - sum(src, capcost(src) * I(src));

MODEL reservoir_management /all/;

SOLVE reservoir_management USING MIP MAXIMIZING total_profit;