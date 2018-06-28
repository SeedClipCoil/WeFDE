function err = Error(dis,st,ed,step)
x=st:step:ed;
y=pdf(dis,x);

err=y;
end