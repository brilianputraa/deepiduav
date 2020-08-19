classdef uavid < parrot
    
    properties
    
        status % Read the connection status to the drone 
        state % Drone State at now and the Flight Mode of the Drone
        dataOut % Exported data type
        result % Variable for saving newest output
        droneObj % Drone object
        
    end
    
    methods
        
        function self = uavid(name, initState, dataOut)
        % Init the variables    
            self.droneObj = self.parrot(name);
            self.status = getStatus(self);
            self.state = setState(initState);
            self.dataOut = dataOut;
            self.result.height = [];
            self.result.speed = [];
            self.result.orientation = [];
            self.result.time = [];
        
        end
        
        function status = getStatus(self)
        % function to check your drone connection by detecting the drone unique ID    
            try
                status = isnumeric(self.droneObj.id);
            catch 
                warning('Please check your drone connection again, make sure it is connected properly');
                status = 0;
            end
        
        end
        
        function result = setState(self, state)
        % Set the state of the drone  
            result = state;
            self.state = result.state;
            self.droneObj.state = self.state;
            
        end
        
        function result = getState(self)
        % Get the latest information about state status    
            result.getState = self.state;
            print(result.getState);
            
        end
        
        function result = setType(self, dataOut)
        % Set the flight data saving file extension
           result.dataOut = dataOut;
           self.dataOut = result.dataOut;
           
        end
        
        function result = getType(self)
        % Get data type for the flight data
           result.dataOut = self.dataOut;
           print(result.dataOut);
           
        end
        
        function result = updateData(self)
            
            self.result.height = [self.result.height; readHeight(self.droneObj)]; % Height of the robot
            self.result.speed = [self.result.speed; readSpeed(self.droneObj)]; % Drone speed around XYZ axis in m/s
            [result.orientation, result.time] = readOrientation(self.droneObj); % ZYX Euler Angles
            self.result.orientation = [self.result.orientation; result.orientation];
            self.result.time = [self.result.time; result.time]; % Saving time step
            
        end
        
        function result = saveData(self)
            
           switch self.dataOut 
               % Saving mechanism for flight data
               case 'csv'
                   
                   result = cell2mat(struct2cell(self.result.height));
                   writematrix(result, 'height.csv')
                   result = cell2mat(struct2cell(self.result.speed));
                   writematrix(result, 'speed.csv')
                   result = cell2mat(struct2cell(self.result.orientation));
                   writematrix(result, 'orientation.csv')
                   result = cell2mat(struct2cell(self.result.time));
                   writematrix(result, 'time.csv')
                   
               otherwise
                   
                   result = cell2mat(struct2cell(self.result.height));
                   save('height.mat', "result")
                   result = cell2mat(struct2cell(self.result.speed));
                   save('speed.mat', "result")
                   result = cell2mat(struct2cell(self.result.orientation));
                   save('orientation.mat', "result")
                   result = cell2mat(struct2cell(self.result.time));
                   save('time.mat', "result")
                   
           end
            
        end
        
    end
    
end