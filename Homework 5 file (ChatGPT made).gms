$onText
CEE 6410
Homework 5

Matthew Fugal
fugalmatt@gmail.com
October 8, 2024
$offText

SETS
    t /1*6/;  

PARAMETERS
    inflow(t)     /1 2, 2 2, 3 3, 4 4, 5 3, 6 2/     
    hp_benefit(t) /1 1.6, 2 1.7, 3 1.8, 4 1.9, 5 2.0, 6 2.0/  
    irr_benefit(t)/1 1.0, 2 1.2, 3 1.9, 4 2.0, 5 2.2, 6 2.2/; 

SCALAR
    initial_storage /5/  
    reservoir_capacity /9/
    turbine_capacity /4/
    min_flow /1/;

VARIABLES
    storage(t)         
    turbine_release(t) 
    bypass_release(t)  
    irrigation(t)      
    river_flow(t)      
    total_profit;

POSITIVE VARIABLES storage, turbine_release, bypass_release, irrigation, river_flow;

EQUATIONS
    water_balance(t)        
    turbine_capacity_limit(t)  
    storage_capacity_limit(t)  
    min_river_flow(t)       
    irrigation_flow(t)      
    end_storage_constraint  
    profit_definition;

water_balance(t).. 
    storage(t) =E= storage(t-1)$(ord(t) > 1) + inflow(t) - turbine_release(t) - bypass_release(t)
                + initial_storage$(ord(t) = 1);

turbine_capacity_limit(t).. 
    turbine_release(t) =L= turbine_capacity;

storage_capacity_limit(t).. 
    storage(t) =L= reservoir_capacity;

min_river_flow(t).. 
    river_flow(t) =G= min_flow;

irrigation_flow(t).. 
    irrigation(t) =E= turbine_release(t) + bypass_release(t) - river_flow(t);

end_storage_constraint.. 
    storage('6') =G= initial_storage;

profit_definition..
    total_profit =E= SUM(t, hp_benefit(t) * turbine_release(t) + irr_benefit(t) * irrigation(t));

MODEL reservoir_management /all/;

SOLVE reservoir_management USING LP MAXIMIZING total_profit;

