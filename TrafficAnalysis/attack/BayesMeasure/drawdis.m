% draw distribution
function drawdis(pdf_set,i,j,style)
x = i:1:j;
y = pdf(pdf_set,x);
plot(x,y,style);