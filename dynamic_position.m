function x1 = dynamic_position(r, a)
    close all
    % initialization
    V_7805 = 5.48;
    Vref_arduino = 5;
    analogWrite(a,6,0);
    analogWrite(a,9,0);
    positionData = [];
    velocityData = [];
    uData = [];
    timeData = [];
    oldZ = [];
    t = 0;
    counter = 0;
    
    
    tic             % start time
    while(t < 5)  
        velocity = analogRead(a, 3);
        position = analogRead(a, 5);
        x1 = 3 * Vref_arduino * position / 1023;                % position
        x2 = 2 * (2 * velocity * Vref_arduino / 1023 - V_7805); % velocity
        % r = 5 + 2 * sin(3 * toc);
        if t ~= 0
            z = (x1 - r) * (toc - timeData(counter)) + oldZ(counter);
            oldZ = [oldZ z];
        else
            z = 0;
            oldZ = [oldZ z];
        end
        u = - 2 * x1 - x2 - 6 * z ;                        % controller
        if u > 0
            analogWrite(a, 6, 0);
            analogWrite(a, 9, min(round(u / 2 * 255 / Vref_arduino), 255));
        else
            analogWrite(a, 9, 0);
            analogWrite(a, 6, min(round(-u / 2 * 255 / Vref_arduino), 255));
        end
        t = toc;
        counter = counter + 1;
        timeData = [timeData t];
        positionData = [positionData x1];
        velocityData = [velocityData x2];
        uData = [uData u];
    end
    analogWrite(a,6,0);
    analogWrite(a,9,0);
    figure
    subplot(4,1,1)
    plot(timeData, positionData);
    title('position')
    subplot(4,1,2)
    plot(timeData, velocityData);
    title('velocity')
    subplot(4,1,3)
    plot(timeData, uData);
    title('controller')
    subplot(4,1,4)
    plot(timeData, oldZ);
    title('z')
end