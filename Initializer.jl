using Random
function ran_init(Sps,n,m,Obs,Seed=1234)
    Random.seed!(Seed);
    u=fill(0.0, length(Sps));
    l=length(Obs);
    theta0=rand(n)
    theta0=theta0/sum(theta0)
    theta=rand(n,n);
    theta=theta ./sum(theta,dims=2)
    psi=rand(n,m);
    psi=psi./sum(psi,dims=2)
    for i = 1:n
        u[Sps["T0"*string(i)*"(t)"]]=theta0[i];
        for j=1:n
            u[Sps["T"*string(i)*string(j)*"(t)"]]=theta[i,j];
        end
        for j=1:m
            u[Sps["T"*string(i)*"_"*string(j)*"(t)"]]=psi[i,j];
        end
    end
    for t=1:l
        A=rand(n);
        A=A/sum(A)
        B=rand(n);
        B=B/sum(B)
        G=rand(n);
        G=G/sum(G)
        xi=rand(n,n);
        xi=xi/sum(xi)
        for i = 1:n
            for j=1:n
                if t!=l
                    u[Sps["Xi"*string(i)*string(j)*"_"*string(t)*"(t)"]]=xi[i,j];
                end
            end
            u[Sps["G"*string(i)*"_"*string(t)*"(t)"]]=A[i];
            u[Sps["A"*string(i)*"_"*string(t)*"(t)"]]=B[i];
            u[Sps["B"*string(i)*"_"*string(t)*"(t)"]]=G[i];  
            u[Sps["B"*string(i)*"_"*string(l)*"(t)"]]=1.0;
        end
        for k=1:m
            if Obs[t][1]+1==k
                u[Sps["E"*string(k)*"_"*string(t)*"(t)"]]=1.0;
            end    
        end   
    end    
    return u                          
end;
function uni_init(Sps,n,m,Obs)
    u=fill(0.0, length(Sps));
    l=length(Obs);
    N=1.0/float(n);
    xi=1.0/float(n*n);
    theta=1.0/float(n);
    psi=1.0/float(m);
    for i = 1:n
        u[Sps["T0"*string(i)*"(t)"]]=theta;
        for j=1:n
            u[Sps["T"*string(i)*string(j)*"(t)"]]=theta;
            for t=1:l-1
                u[Sps["Xi"*string(i)*string(j)*"_"*string(t)*"(t)"]]=xi;
            end
        end    
        for t=1:l
            u[Sps["G"*string(i)*"_"*string(t)*"(t)"]]=N;
            u[Sps["A"*string(i)*"_"*string(t)*"(t)"]]=N;
            u[Sps["B"*string(i)*"_"*string(t)*"(t)"]]=N;  
        end
        u[Sps["B"*string(i)*"_"*string(l)*"(t)"]]=1.0;
        for j=1:m
            u[Sps["T"*string(i)*"_"*string(j)*"(t)"]]=psi;
        end
    end
    for t=1:l
        for k=1:m
            if Obs[t][1]+1==k
                u[Sps["E"*string(k)*"_"*string(t)*"(t)"]]=1.0;
            end    
        end   
    end    
    return u                          
end
;      