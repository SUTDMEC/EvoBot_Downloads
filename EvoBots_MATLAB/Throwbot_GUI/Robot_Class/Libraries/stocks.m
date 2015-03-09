classdef stocks < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Symbol
        OpeningPrices
    end
    
    methods
        function setSymbol(obj,Symbol)
            obj.Symbol = Symbol;
        end
        function two(obj)
            obj.OpeningPrices = 5;
        end
        
    end
    
end

