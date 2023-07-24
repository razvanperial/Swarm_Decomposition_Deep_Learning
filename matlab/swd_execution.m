sum_less_than_3 = 0;

% Loop over files
for file_idx = 1:14
    % Load the data file
    file_name = sprintf('P_%d.mat', file_idx);
    load(file_name, 'data'); % Assuming each file contains the data in variable 'val'
    
    % Get the number of instances (x) in the current file
    num_trials = size(data, 1);
    
    % Create a directory to store the SWD results for the current file
    dir_name = sprintf('Results_%d', file_idx); % Update the directory name pattern accordingly
    mkdir(dir_name);
    
    % Initialize variables to store SWDs and labels for the current file
    file_swds = {};  % Cell array to store SWDs
    
    % Loop over instances
    for instance_idx = 1:num_trials
        
        instance_swds = {};
        
        has_less_than_3 = false;
        
        % Loop over all channels
        for channel_idx = 1:11
            
            % Extract the EEG data for the current instance
            x = data(instance_idx, channel_idx, :);
            x = squeeze(x);
            
            % Preprocessing steps
            x = (x - mean(x)) / max(abs(x));
            x = double(transpose(x));
            fs = 250;
            dt   = 1 / fs;
            L    = length(x);
            t    = 0:dt:(L - 1) * dt;
            nfft = 2 ^ nextpow2(L);
            X    = abs(fft(x, nfft)) / L;
            f    = (fs / 2) * linspace(0, 1, nfft/2);
            
             % Bandpass filtering
            [b, a] = butter(5, [7 30] / (fs / 2), 'bandpass');
            x_filt = filtfilt(b, a, x);
            nfft   = 2 ^ nextpow2(length(x_filt));
            X_filt = abs(fft(x_filt, nfft)) / nfft;
            f      = (fs / 2) * linspace(0, 1, nfft/2);
            
            % downsamping
            q = 2;
            fs2   = fs / q;
            dt2   = 1 / fs2;
            x_dec = resample(x_filt, 1, q);
            L_dec = length(x_dec);
            nfft  = 2 ^ nextpow2(L_dec);
            X_dec = abs(fft(x_dec, nfft)) / L_dec; 
            t2    = 0:dt2:(length(x_dec) - 1) * dt2;
            f2    = (fs2 / 2) * linspace(0, 1, nfft/2);
            
            % Prepare for SWD execution
            L1 = length(x_dec);
            padding_length = L1 - length(x);
            s_SWD = [x_dec, zeros(1, padding_length)];
            L2 = length(s_SWD);

            % Set SWD parameters
            param_struct = struct('P_th', 0.2, ...
                'StD_th', 0.125, ...
                'Welch_window', 64, ...
                'Welch_no_overlap', 32, ...
                'Welch_nfft', 64);
             
            % Execute SWD
            y_SWD_res = SwD(s_SWD, param_struct);
            y_SWD = y_SWD_res.';  
            
            if size(y_SWD,1) < 3
                has_less_than_3 = true;
                break;
            end
            
            % extract only the first 3 OCMs
            instance_swds{end+1} = y_SWD(1:3, :);
            
            % plot the results
            %{
            no_comp_SWD = size(y_SWD, 1);
            figure; 
            for i = 1:1:no_comp_SWD
                subplot(no_comp_SWD, 1, i); plot(t2, y_SWD(i, 1:L1));   
            end
            %}
        end
        
        if ~has_less_than_3
            file_swds{end+1} = instance_swds;
        end
        
        % Save the SWDs and labels for the current file in a MAT file
        % file_data_file_name = fullfile(dir_name, sprintf('file_data_%d.mat', file_idx));
        % save(file_data_file_name, 'file_swds');     
    end
    % Save the SWDs and labels for the current file in a MAT file
    file_data_file_name = fullfile(dir_name, sprintf('file_data_%d.mat', file_idx));
    save(file_data_file_name, 'file_swds');
end
