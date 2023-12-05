function T = FindThreshold(f,g)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    T_min=max(min(f),min(g)); % tim gia tri lon nhat cua minf va ming
    T_max=min(max(f),max(g)); % tim gia tri nho nhat cua maxf va maxg
    
   
    T= 0.5*(T_min+T_max);
    j= -1; q= -1;
    
    i=sum(f(f < T));
    p=sum(g(g > T));
 
while( i~=j || p~=q ) % dung thuat toan tim kiem nhi phan theo cs425
    %De tim nguong T 
    result = sum (f(f - T > 0)) - sum (g(T -g > 0));
    if(result >= 0)
        Tmin = T;
    else
        Tmax = T;
    end
    T=0.5*(T_min+T_max);    
    j=i; q=p;
    i=sum(f(f<T));
    p=sum(g(g>T));
  
end

