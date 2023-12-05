function data =nor(f,T)
    for i=1 : length(f)
        if(f(i) >= T)
            data(i) = (f(i)-T)/ (max(f)-T);% chuan hoa dau ve doan [0; 1]
        else
            data(i) = (f(i)-T)/ (T-min(f));% chuan hoa dau ve doan [-1; 0]
        end
    end
           
end
