classdef Channel_attentionLayer < nnet.layer.Layer 
    properties
        % (Optional) Layer properties.
        channel
        % Layer properties go here.
    end
    properties (Learnable)
        % (Optional) Layer learnable parameters.
        w1
        w2
        % Layer learnable parameters go here.
    end
    methods
       function layer = Channel_attentionLayer(name,channel,c)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            layer.Name = name;
            sub_c = fix(channel/c);
            layer.channel=channel;
            layer.w1 = ones(sub_c,channel);
            layer.w2 = ones(channel,sub_c);
            % Layer constructor function goes here.
       end
        
       
        function Z = predict(layer,X)
            X_gmax = max(X,[],[1,2]);
            X_gmean = mean(X,[1,2]);
            
            X_gmax = reshape(X_gmax,layer.channel,1,[]);
            X_gmean = reshape(X_gmean,layer.channel,1,[]);
            
            X_gmax_weighted_1 = pagemtimes(layer.w1,X_gmax);
            X_gmax_weighted   = pagemtimes(layer.w2,X_gmax_weighted_1);
            X_gmean_weighted_1 = pagemtimes(layer.w1,X_gmean);
            X_gmean_weighted   = pagemtimes(layer.w2,X_gmean_weighted_1);
            
            X_gmax_weighted   = dlarray(X_gmax_weighted,'SSB');
            X_gmean_weighted   = dlarray(X_gmean_weighted,'SSB');
            
            X_gmax_sigmoid = sigmoid(X_gmax_weighted);
            X_gmean_sigmoid = sigmoid(X_gmean_weighted);
            
            X_attention = X_gmax_sigmoid + X_gmean_sigmoid;
            X_attention = reshape(X_attention,1,1,layer.channel,[]);
            Z = pagemtimes(X,X_attention);
        end

    end
end