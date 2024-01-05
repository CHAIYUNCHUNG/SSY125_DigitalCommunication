function bits_de = softdecode_bpsk(y,Map,G)
    Nb = length(y);
    Ns = 2^((length(G)-1));
    bits_de = zeros(1,Nb);
    remain = nan(Ns,Nb + 1);   
    branch = nan(Ns,Ns);    
    path = zeros(Ns,Nb + 1);            
    final_path_state = zeros(1,Nb + 1);

    [~,next,output] = stategenerator(G);

    for t = 1:Nb
        for state = 0:Ns-1
        % for each input bit 0,1
            for bit = 0:1
                % get next state and possible bit  
                nextstate = bi2de(flip(next(state+1+Ns*bit,:)));    % Decimal number
                output_bit = output(state+1+Ns*bit,:);
                branch(state+1,nextstate+1) = bpskdis(Map(bi2de(flip(output_bit))+1),y(t));  
            end
        end
        for state = 0:Ns-1
            % current path + next possible branch
            % minimum accumulated path 
            [value, index] = min(path(:,t) + branch(:,state+1));
            % save the minimum path to path matrix
            path(state+1, t+1) = value;
            if ~isnan(value)
                % save the survived state 
                remain(state+1, t+1) = index - 1;
            end
        end
        branch(:)= NaN;
    end
    
    % Trace back
    state = 0;
    for i = Nb+1 : -1 : 1
        final_path_state(i) = state;
        state = remain(state+1, i);
    end
    
    for i = 1:Nb
        possible_state = [bi2de(flip(next(final_path_state(i)+1,:))), bi2de(flip(next(final_path_state(i)+1+Ns,:)))];
        predict_state = final_path_state(i+1);
        % corresponds to next_state column, 
        % 1st column -> bit 0, 2nd column -> bit 1
        bits = find(possible_state == predict_state ) - 1;
        bits_de(i) = bits;
    end

end