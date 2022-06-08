classdef Spatial_attentionLayer < nnet.layer.Layer 
    methods
       function layer = Spatial_attentionLayer(name)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            layer.Name = name;
            % Layer constructor function goes here.
        end
        function A = predict(layer,X)
            
            X_max = max(X,[],3);
            X_mean = mean(X,3);
            A = cat(3,X_max,X_mean);
        end

    end
end