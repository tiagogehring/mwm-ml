classdef config_place_avoidance < base_config
    % config_mwm Global constants
    properties(Constant)
        RESULTS_DIR = 'results/place_avoidance_t1';
                
        TRIAL_TYPE_HABITUATION = 1;
        TRIAL_TYPE_TRAINING = 2;
        TRIAL_TYPE_TEST = 3;
        
        TRIAL_TYPES_DESCRIPTION = { ...            
            'Habituation', ...
            'Training', ...
            'Testing' ...
        };                    
    
        % centre point of arena in cm        
        CENTRE_X = 127.5;
        CENTRE_Y = 127.5;
        % radius of the arena
        ARENA_R = 127.5;
                	
        REGULARIZE_GROUPS = 0;
        NDISCARD = 0;        
                        
        % trajectory sample status
        POINT_STATE_OUTSIDE = 0;
        POINT_STATE_ENTRANCE_LATENCY = 1;
        POINT_STATE_SHOCK = 2;
        POINT_STATE_INTERSHOCK_LATENCY = 3;
        POINT_STATE_OUTSIDE_LATENCY = 4;
        POINT_STATE_BAD = 5;
                                    
        CLUSTER_CLASS_MINIMUM_SAMPLES_P = 0.01; % 2% o
        CLUSTER_CLASS_MINIMUM_SAMPLES_EXP = 0.75;
        
        FEATURE_AVERAGE_SPEED_ARENA = base_config.FEATURE_LAST + 1;
        FEATURE_VARIANCE_SPEED_ARENA = base_config.FEATURE_LAST + 2;
        FEATURE_LENGTH_ARENA = base_config.FEATURE_LAST + 3;
        FEATURE_LOG_RADIUS = base_config.FEATURE_LAST + 4;
        FEATURE_IQR_RADIUS_ARENA = base_config.FEATURE_LAST + 5;        
        FEATURE_TIME_CENTRE = base_config. FEATURE_LAST + 6; 
        FEATURE_NUMBER_OF_SHOCKS = base_config.FEATURE_LAST + 7; 
        FEATURE_FIRST_SHOCK = base_config.FEATURE_LAST + 8; 
        FEATURE_MAX_INTER_SHOCK = base_config.FEATURE_LAST + 9; 
        FEATURE_ENTRANCES_SHOCK = base_config.FEATURE_LAST + 10; 
        FEATURE_ANGULAR_DISTANCE_SHOCK = base_config.FEATURE_LAST + 11;        
        FEATURE_SHOCK_RADIUS = base_config.FEATURE_LAST + 12;            
                                                             
        DEFAULT_FEATURE_SET = [ base_config.FEATURE_LATENCY, ...
                                config_place_avoidance.FEATURE_AVERAGE_SPEED_ARENA, ...                                                                                                
                                config_place_avoidance.FEATURE_VARIANCE_SPEED_ARENA, ...
                                config_place_avoidance.FEATURE_TIME_CENTRE, ...
                                config_place_avoidance.FEATURE_NUMBER_OF_SHOCKS, ... 
                                config_place_avoidance.FEATURE_FIRST_SHOCK, ...
                                config_place_avoidance.FEATURE_MAX_INTER_SHOCK, ...
                                config_place_avoidance.FEATURE_ENTRANCES_SHOCK, ...
                                config_place_avoidance.FEATURE_SHOCK_RADIUS, ...
                                base_config.FEATURE_LENGTH ...                                
                              ];
                          
        CLUSTERING_FEATURE_SET = [ base_config.FEATURE_DENSITY, ...
                                   config_place_avoidance.FEATURE_ANGULAR_DISTANCE_SHOCK, ...
                                   config_place_avoidance.FEATURE_LOG_RADIUS ...
                                 ];
                                                                          
        % plot properties
        OUTPUT_DIR = '/home/tiago/results/'; % where to put all the graphics and other generated output
        CLASSES_COLORMAP = @jet;   
                 
        % which part of the trajectories are to be taken
        SECTION_T1 = 1; % segment until first entrance to the shock area
        SECTION_TMAX = 2; % longest segment between shocks
        SECTION_AVOID = 3; % segments between shocks
        SECTION_FULL = 0; % complete trajectories
        
        DATA_REPRESENTATION_ARENA_COORD = base_config.DATA_REPRESENTATION_LAST + 1;
        DATA_REPRESENTATION_ARENA_SPEED = base_config.DATA_REPRESENTATION_LAST + 2;
        DATA_REPRESENTATION_SHOCKS = base_config.DATA_REPRESENTATION_LAST + 3;
        DATA_REPRESENTATION_ARENA_SHOCKS = base_config.DATA_REPRESENTATION_LAST + 4;
        
        %%%
        %%% DATA SETS
        %%%
        DATA_SET_SMALL = 1;
        DATA_SET_LARGE = 2;
        DATA_SET_SILVER = 3;

        % groups for the large group
        GROUP_CONTROL = 1;
        GROUP_MK_HIGH = 2;
        GROUP_MK_MEDIUM = 3;
        GROUP_MK_LOW = 4;
        GROUP_MEM_HIGH = 5;
        GROUP_MEM_MEDIUM = 6;
        GROUP_MEM_LOW = 7;
                 
        %%%
        %%% Segmentation
        %%%
        SEGMENTATION_PLACE_AVOIDANCE = base_config.SEGMENTATION_LAST + 1;       
                %%        
                
        
    end   
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        ROTATION_FREQUENCY = 1;
        TAGS_CONFIG = [];
        SET = [];        
        TRIAL_TIMEOUT = 1200; % seconds
        TRIALS_PER_SESSION = [];
        TRIAL_TYPE = [];
        TRIALS = [];
        SESSIONS = [];        
        GROUPS = [];
        GROUPS_DESCRIPTION = {};
        SHOCK_AREA_ANGLE = [];
    end
    
    methods        
        function inst = config_place_avoidance(set)            
            if set == config_place_avoidance.DATA_SET_SMALL
                name = 'Place avoidance task (small set)';
            elseif set == config_place_avoidance.DATA_SET_LARGE
                name = 'Place avoidance task (large set)';
            else                
                name = 'Place avoidance task [silver]';
            end
            addpath(fullfile(fileparts(mfilename('fullpath')), 'place_avoidance'));    
            inst@base_config(name, ...                
               [ tag('TT', 'thigmotaxis', base_config.TAG_TYPE_BEHAVIOUR_CLASS, 1), ... % default tags
                 tag('IC', 'incursion', base_config.TAG_TYPE_BEHAVIOUR_CLASS, 2), ...
                 tag('SS', 'scanning-surroundings', base_config.TAG_TYPE_BEHAVIOUR_CLASS, 7), ...                 
                 tag('CP', 'close pass', base_config.TAG_TYPE_TRAJECTORY_ATTRIBUTE), ...
                 tag('S1', 'selected 1', base_config.TAG_TYPE_TRAJECTORY_ATTRIBUTE) ], ...                 
               { {'Arena coordinates', base_config.DATA_TYPE_COORDINATES, 'trajectory_arena_coord' }, ...
                 {'Speed (arena)', base_config.DATA_TYPE_SCALAR_FIELD, 'trajectory_speed', 'DataRepresentation', config_place_avoidance.DATA_REPRESENTATION_ARENA_COORD}, ...
                 {'Shock events', base_config.DATA_TYPE_EVENTS, 'trajectory_events', config_place_avoidance.POINT_STATE_SHOCK}, ...
                 {'Shock events (arena)', base_config.DATA_TYPE_EVENTS, 'trajectory_events', config_place_avoidance.POINT_STATE_SHOCK, 'DataRepresentation', config_place_avoidance.DATA_REPRESENTATION_ARENA_COORD} ...
               }, ...
               { {'Va', 'Average speed (arena)', 'trajectory_average_speed', 1, 'DataRepresentation', config_place_avoidance.DATA_REPRESENTATION_ARENA_COORD}, ...
                 {'Va_var', 'Log variance speed (arena)', 'feature_transform', 1, @log, 'trajectory_variance_speed', 'DataRepresentation', config_place_avoidance.DATA_REPRESENTATION_ARENA_COORD}, ...
                 {'L_A', 'Length (arena)', 'trajectory_length', 1, 'DataRepresentation', config_place_avoidance.DATA_REPRESENTATION_ARENA_COORD}, ...
                 {'log_R12', 'Log-radius', 'trajectory_radius', 1, 'TransformationFunc', @(x) -log(x), 'AveragingFunc', @(X) mean(X)}, ...
                 {'Riqr_A', 'IQR radius (arena)', 'trajectory_radius', 2, 'DataRepresentation', config_place_avoidance.DATA_REPRESENTATION_ARENA_COORD}, ...
                 {'Tc_A', 'Time centre', 'trajectory_time_within_radius', 1, 0.75*config_place_avoidance.ARENA_R, 'DataRepresentation', config_place_avoidance.DATA_REPRESENTATION_ARENA_COORD}, ...
                 {'N_s', 'Number of shocks', 'trajectory_count_events', 1, config_place_avoidance.POINT_STATE_SHOCK}, ...
                 {'T1', 'Time for first shock', 'trajectory_first_event', 1, config_place_avoidance.POINT_STATE_SHOCK}, ...
                 {'Tmax', 'Maximum time between shocks', 'trajectory_max_inter_event', 1, config_place_avoidance.POINT_STATE_SHOCK}, ...
                 {'Nent', 'Number of entrances', 'trajectory_entrances_shock', 1}, ...
                 {'D_ang', 'Ang. distance shock', 'trajectory_angular_distance_shock', 1}, ...                 
                 {'R_s', 'Shock radius', 'trajectory_event_radius', 1, config_place_avoidance.POINT_STATE_SHOCK}, ...                 
               }, ...
               { {'Place avoidance', 'segmentation_place_avoidance'} } ...
            );               
        
            inst.SET = set;
            if set == config_place_avoidance.DATA_SET_SMALL
                %% Tags sets - number/indices have to match the list below        
                %%        
                inst.TAGS_CONFIG = { ... % values are: file that stores the tags, segment length, overlap, default number of clusters
                    { '/home/tiago/neuroscience/place_avoidance/labels_full.csv', 0, 0}, ...
                    { '/home/tiago/neuroscience/place_avoidance/labels_t1.csv', 10, config_place_avoidance.SEGMENTATION_PLACE_AVOIDANCE, 1, config_place_avoidance.SECTION_AVOID, 6} ...
                };                
                inst.SESSIONS = 5;
                inst.TRIALS_PER_SESSION = [1 1 1 1 1];                
                inst.TRIAL_TYPE = [ config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TEST ];
                inst.GROUPS = 2;                
            elseif set == config_place_avoidance.DATA_SET_LARGE
                inst.TAGS_CONFIG = { ... % values are: file that stores the tags, segment length, overlap, default number of clusters
                    { '/home/tiago/neuroscience/place_avoidance/labels_full_large.csv', 0, 0}, ...
                    { '/home/tiago/neuroscience/place_avoidance/labels_t1_large.csv', 10, config_place_avoidance.SEGMENTATION_PLACE_AVOIDANCE, 1, config_place_avoidance.SECTION_AVOID, 6} ...
                };
                inst.TRIALS_PER_SESSION = [4 4 4 4];
                inst.SESSIONS = 4;                                     
                inst.TRIAL_TYPE = repmat([ config_place_avoidance.TRIAL_TYPE_HABITUATION, ...
                                           config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                           config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                           config_place_avoidance.TRIAL_TYPE_TEST ], 1, 4);
                inst.GROUPS = 7;
                inst.GROUPS_DESCRIPTION = { ...
                    'Control', ...
                    'MK-801H', ...
                    'MK-801M', ...
                    'MK-801L', ...
                    'MemH', ...
                    'MemM', ...
                    'MemL' ...
                };
                inst.SHOCK_AREA_ANGLE = pi/180*[225, 315, 135, 45];                    
            else
                inst.TAGS_CONFIG = { ... % values are: file that stores the tags, segment length, overlap, default number of clusters
                    { '/home/tiago/neuroscience/place_avoidance/labels_silver_large.csv', 0, 0}, ...
                    { '/home/tiago/neuroscience/place_avoidance/labels_t1_silver.csv', 10, config_place_avoidance.SEGMENTATION_PLACE_AVOIDANCE, 1, config_place_avoidance.SECTION_AVOID, 6} ...
                };
                inst.SESSIONS = 6;  
                inst.TRIALS_PER_SESSION = ones(1, inst.SESSIONS);              
                inst.TRIAL_TYPE = [ config_place_avoidance.TRIAL_TYPE_TRAINING ...
                                    config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TRAINING, ...
                                    config_place_avoidance.TRIAL_TYPE_TEST ];
                inst.GROUPS = 2;
                inst.GROUPS_DESCRIPTION = { ...
                    'Control', ...
                    'Silver', ...                    
                };
                inst.SHOCK_AREA_ANGLE = pi/180*225*ones(1, inst.SESSIONS); 
            end
            inst.TRIALS = sum(inst.TRIALS_PER_SESSION);
        end
               
        % Imports trajectories from Noldus data file's
        function traj = load_data(inst)
            addpath(fullfile(fileparts(mfilename('fullpath')),'../import/place_avoidance'));

            if inst.SET == config_place_avoidance.DATA_SET_SMALL
                traj = load_trajectories('/home/tiago/neuroscience/place_avoidance/data1', ...                    
                    [1093, 1; ...
                     1094, 1; ...
                     1095, 1; ...
                     1096, 1; ...
                     1097, 2; ...
                     1098, 2; ...
                     1099, 2; ...
                     1100, 2; ...
                     1101, 2; ...
                     1102, 2; ...
                     1103, 2; ...
                     1104, 2; ...                 
                     1105, 1; ...
                     1106, 1; ...
                     1107, 1; ...
                     1108, 1; ...                 
                    ] ...
                );
            elseif inst.SET == config_place_avoidance.DATA_SET_LARGE
                root = '/home/tiago/place_avoidance/data2/';
                traj = trajectories([]);
                sub_folders = {'control', 'MK_high', 'MK_medium', 'MK_low', 'mem_high', 'mem_medium', 'mem_low' };
                groups = [ config_place_avoidance.GROUP_CONTROL, ...
                           config_place_avoidance.GROUP_MK_HIGH, ...
                           config_place_avoidance.GROUP_MK_MEDIUM, ...
                           config_place_avoidance.GROUP_MK_LOW, ...
                           config_place_avoidance.GROUP_MEM_HIGH, ...
                           config_place_avoidance.GROUP_MEM_MEDIUM, ...
                           config_place_avoidance.GROUP_MEM_LOW ];
                
                % renumber tracks - otherwise we will have collisions
                track = 1;
                % for all days
                for d = 1:5
                    day = d;                    
                    real_day = d;
                    if d == 5
                        day = 21; % == day 4 too
                        real_day = 4;
                    end
                    
                    for f = 1:length(sub_folders)
                        % load training part (divided in 3 x 5 min trials)
                        pat = sprintf('*d%dtr*Room*.dat', day);     
                        new_traj = load_trajectories([root, sub_folders{f}], groups(f), 'FilterPattern', pat, 'IdDayMask', 'r%dd%d'); 
                        % break them down in 3 trajectories
                        for t = 1:new_traj.count
                            pos1 = find(new_traj.items(t).points(:, 1) > 5*60);
                            if isempty(pos1)
                                continue;
                            end
                            traj = traj.append( trajectory( new_traj.items(t).points(1:pos1(1) - 1, :), ...
                                                     new_traj.items(t).set, ...
                                                     track, ...
                                                     new_traj.items(t).group, ...
                                                     new_traj.items(t).id, ...
                                                     (real_day - 1)*4 + 1, ...
                                                     1, ...
                                                     0, ...
                                                     1 ) );
                            track = track + 1;
                            pos2 = find(new_traj.items(t).points(:, 1) > 10*60);
                            if isempty(pos2)
                                continue;
                            end
                            traj = traj.append( trajectory( new_traj.items(t).points(pos1(1):pos2(1) - 1, :), ...
                                                     new_traj.items(t).set, ...
                                                     track, ...
                                                     new_traj.items(t).group, ...
                                                     new_traj.items(t).id, ...
                                                     (real_day - 1)*4 + 2, ...
                                                     1, ...
                                                     0, ...
                                                     1 ) );
                            track = track + 1;
                            pos3 = find(new_traj.items(t).points(:, 1) > 15*60);
                            if isempty(pos3)
                                pos3 = size(new_traj.items(t).points, 1) + 1;
                            end
                            traj = traj.append( trajectory( new_traj.items(t).points(pos2(1):pos3(1) - 1, :), ...
                                                     new_traj.items(t).set, ...
                                                     track, ...
                                                     new_traj.items(t).group, ...
                                                     new_traj.items(t).id, ...
                                                     (real_day - 1)*4 + 3, ...
                                                     1, ...
                                                     0, ...
                                                     1 ) );                                                 
                            track = track + 1;
                        end
                        
                        % load testing part (5 min)
                        pat = sprintf('*d%dts*Room*.dat', day);     
                        new_traj = load_trajectories([root, sub_folders{f}], groups(f), 'FilterPattern', pat, 'IdDayMask', 'r%dd%d');
                        % correct trial and track number
                        for t = 1:new_traj.count
                            new_traj.items(t).set_trial( real_day*4 );
                            new_traj.items(t).set_track( track );
                            track = track + 1;
                        end
                        traj = traj.append(new_traj);
                    end
                end
            else
               % "Silver" set
               folder = '/home/tiago/place_avoidance/data3/';      
               % control
               traj = load_trajectories(folder, 1, 'FilterPattern', 'ho*Room*.dat', 'IdDayMask', 'hod%dr%d', 'ReverseDayId', 1); 
               % silver
               traj = traj.append(load_trajectories(folder, 2, 'FilterPattern', 'nd*Room*.dat', 'IdDayMask', 'nd%dr%d', 'ReverseDayId', 1));
            end
        end        
    end
end