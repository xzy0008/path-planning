function robot(obj, event, string_arg)

r = java.awt.Robot;
lett = 'THANKS';
for k = 1:length(lett)
eval(['r.keyPress(java.awt.event.KeyEvent.VK_ENTER)'])
end