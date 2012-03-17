function o = cut(a,m0,n0,m,n)
%CUT cuts out submatrix or centered submatrix or completes with zeros 
%
%   function o = cut(a,m0,n0,m,n)
%   function o = cut(a,m,n)     window is centered
%                               or completed with zeros
%   function o = cut(a,[m,n])
%
%   a ... matrix or cell array of matrices
%   m,n     ... size of resulting image
%   m0,n0   ... coordinates of the upper-left corner 
%               in the source matrix a
%   if m0,n0<0 ... it gives difference of how many pixels to shrink
%
%Michal Sorel (c) 2004, 2005, 2006, 2008

if ~iscell(a)    
    [mi,ni] = size(a);
    if nargin == 5 | (nargin==2 & length(m0) == 4) % height, width given
        if nargin == 2 % m0 = [m0 n0 height width]                   
            n0 = m0(2);
            m = m0(3);
            n = m0(4);    
            m0 = m0(1);
        end    
        o = zeros(m,n);
        mo1 = max(1,m0);
        mo2 = min(mi,m0+m-1);
        no1 = max(1,n0);
        no2 = min(ni,n0+n-1);

        mm = max(2-m0,1);
        nn = max(2-n0,1);
        if mo2 >= mo1 & no2 >= no1
            %o(1:mo2-mo1+1,1:no2-no1+1) = a(mo1:mo2,no1:no2);
            o(mm:mo2-mo1+mm,nn:no2-no1+nn) = a(mo1:mo2,no1:no2);
        end
    else                % hegiht, width must be computed
        if nargin == 2        
            n0 = m0(2);            
            m0 = m0(1);
        end    
        if m0 < 0, m0 = mi+m0; end
        if n0 < 0, n0 = ni+n0; end
        m = m0; % desired size
        n = n0;
        o = zeros(m,n);

        if m > mi
            m1 = floor((m-mi)/2)+1;
            m0 = 1;
        else
            m0 = floor((mi - m)/2)+1;
            m1 = 1;
        end

        if n > ni
            n1 = floor((n-ni)/2)+1;
            n0 = 1;
        else
            n0 = floor((ni - n)/2)+1;
            n1 = 1;
        end 

        m = min(m,mi);
        n = min(n,ni);    

        o(m1:m1+m-1,n1:n1+n-1) = a(m0:m0+m-1,n0:n0+n-1);
    end
else % if iscell(a)
    o = cell(size(a));      
    if nargin == 5 | (nargin==2 & length(m0) == 4) % height, width given
        if nargin == 2 % m0 = [m0 n0 height width]                   
            n0 = m0(2);
            m = m0(3);
            n = m0(4);    
            m0 = m0(1);
        end    
        for i = 1:numel(a)
            o{i} = zeros(m,n);
            [mi,ni] = size(a{i});
            mo1 = max(1,m0);
            mo2 = min(mi,m0+m-1);
            no1 = max(1,n0);
            no2 = min(ni,n0+n-1);

            mm = max(2-m0,1);
            nn = max(2-n0,1);
            if mo2 >= mo1 & no2 >= no1
                %o{i}(1:mo2-mo1+1,1:no2-no1+1) = a{i}(mo1:mo2,no1:no2);                              
                o{i}(mm:mo2-mo1+mm,nn:no2-no1+nn) = a{i}(mo1:mo2,no1:no2);
            end
        end
    else                % hegiht, width must be computed
        if nargin == 2        
            n0 = m0(2);            
            m0 = m0(1);
        end    
        for i = 1:numel(a)
            [mi,ni] = size(a{i});
            if m0 < 0, m0p = mi+m0; else m0p = m0; end
            if n0 < 0, n0p = ni+n0; else n0p = n0; end
            m = m0p; % desired size
            n = n0p;
            o{i} = zeros(m,n);

            if m > mi
                m1 = floor((m-mi)/2)+1;
                m0p = 1;
            else
                m0p = floor((mi - m)/2)+1;
                m1 = 1;
            end

            if n > ni
                n1 = floor((n-ni)/2)+1;
                n0p = 1;
            else
                n0p = floor((ni - n)/2)+1;
                n1 = 1;
            end 
            m = min(m,mi);
            n = min(n,ni);              
            o{i}(m1:m1+m-1,n1:n1+n-1) = a{i}(m0p:m0p+m-1,n0p:n0p+n-1);
        end
    end        
end