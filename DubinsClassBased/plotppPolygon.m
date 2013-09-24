function out=plotppPolygon(polygon,option)
    if nargin==1
        option=[0.92 0.92 0.92];
    end
%     plot([polygon.x polygon.x(1)], [polygon.y polygon.y(1)],'Color',[0 0.398 0]);
    h=fill([polygon.x], [polygon.y],option);
    set(h,'EdgeColor','none')
end