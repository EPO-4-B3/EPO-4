classdef car 
    properties
	%car properties
	position		% reference positionx at time t0
	velocity = [0,0];		% init value is needed!
    acceleration = [0,0];
    force
    vAngle = 0;
    angle %steering angle
	time
    status; % -1 = crash, 0 = off, 1 = on, 2=success
    end

    methods
        
    %constructor
	function obj = car(x,f,alpha)
	    % constructor (same name as class); returns initialized object
	    if nargin == 0
            % if no input arguments
	        x = [0,0];
            f=0;
            alpha=0;
	    end	
	    obj.position = x;   % (calls set.positionx; also starts timer)
	    obj.velocity = [0,0];	% calls set.velocity (thus, init value needed)
        obj.acceleration = calcA(f,alpha);
        obj.angle=alpha;
        obj.force=f;
        obj.status=0;
    end

    %display method
	function disp(obj)
	    % disp prints the object's values
	    % first update position based on current time and velocity
        global x
        statustext=["crash", "off", "on", "success"];
	    x = obj.position;
	    v = obj.velocity;
        a = obj.acceleration;
        f = obj.force;
	    t = obj.time;
        stat = obj.status;

	    disp("position: " + x);
        disp("velocity: " + v);
        disp("acceleration: " + a);
        disp("status: " + statustext(stat+2));
	    disp("time since last update: "+toc(t));
    end

    
    
    %set methods    
    function obj = set.position(obj,x)
	    %when 'position' is set, also reset time; leave v the same
	    obj.position = x;           % set current position
        obj.time = tic;             % store current time
    end
    
	function obj = set.velocity(obj,v)
	    %first update positionx based on the old velocity
        xTemp = obj.position;		% calls get.position, gives x at t1, not t0
        obj.position = xTemp;		% calls set.position; resets timer
        obj.velocity = v;           % then, update velocity
    end
    
	function obj = set.acceleration(obj,a)
	    %first update position and velocity based on the old acceleration
        vTemp = obj.velocity;		% calls get.velocity, gives v at t1, not t0
        obj.velocity = vTemp;		% calls set.velocity; resets timer
        obj.acceleration = a;		% then, update velocity
    end
    
	function obj = set.force(obj,f)
	    %first update position, velocity and accel based on the old force
        aTemp = obj.acceleration;		% calls get.acceleration, gives a at t1, not t0
        obj.acceleration = aTemp;		% calls set.acceleration; resets timer
        obj.force = f;                  % then, update force
    end
    
	function obj = set.status(obj,stat)
	    % first update positionx based on the old velocity
        obj.status = stat;
    end
    

    
    
    
    
    %get methods
	function x = get.position(obj)
	    % when 'positionx' is queried, calculate current positionx
	    % (note, cannot update it because 'obj' is not an output param)
            t0 = obj.time;		% t0 = time when last called
            x0 = obj.position;		% x0 = positionx at time t0
            v = obj.velocity;		% v = velocity at time t0
            a = obj.acceleration;		% a = acceleration at time t0
            T = toc(t0);		% elapsed time (in seconds) since t0
            if (obj.status == 1)
                x = x0 + v*T ; %+ 0.5*a*T^2
            else		
               x=x0;
            end
    end
  
	function v = get.velocity(obj)
	    % when 'positionx' is queried, calculate current positionx
	    % (note, cannot update it because 'obj' is not an output param)
            t0 = obj.time;		% t0 = time when last called
            v0 = obj.velocity;		% v0 = velocity at time t0
            a = obj.acceleration;		% v = accel at time t0

            T = toc(t0);		% elapsed time (in seconds) since t0

            if (obj.status == 1)
                v = v0 + a*T;		% current velocity based on elapsed time
            else
                v = 0;
            end
    end
      
	function a = get.acceleration(obj)
            a = obj.acceleration;
    end
      
    function stat = get.status(obj) %cr is the status
        global x
            if(obj.status~=-1 & (x > 600 | x < 0))
                obj.status=-1;	
            end
                stat = obj.status;
    end
    
end
end