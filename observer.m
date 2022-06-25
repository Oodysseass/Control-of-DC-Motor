function x1 = observer(r, a)
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
    t = 0;
    counter = 0;
    oldX1 = [];
    oldX2 = []; 
    x1real = [];
    x1guesses = [];
    x2real = [];
    x2guesses = [];
    
    tic             % start time
    while(t < 5)  
        velocity = analogRead(a, 3);
        position = analogRead(a, 5);
        x1 = 3 * Vref_arduino * position / 1023;                % position
        x2 = 2 * (2 * velocity * Vref_arduino / 1023 - V_7805); % velocity
        % r = 5 + 2 * sin(3 * toc);
        u = sin(4 * toc);
        if t ~= 0
            x1obs = dx1 * (toc - timeData(counter)) + oldX1(counter);
            dx1 = -1.755 * x2obs + 4 * (x1 - x1obs);
            oldX1 = [oldX1 x1obs];
            x2obs = dx2 * (toc - timeData(counter)) + oldX2(counter);
            dx2 = -2.105 * x2obs + 1.895 * u - 10 * (x1 - x1obs);
            oldX2 = [oldX2 x2obs];
        else
            x1obs = x1;
            x2obs = 0;
            dx1 = -1.755 * x2obs + 4 * (x1 - x1obs);
            dx2 = -2.105 * x2obs + 1.895 * u - 10 * (x1 - x1obs);
            oldX1 = [oldX1 x1obs];
            oldX2 = [oldX2 x2obs];
        end
        if u > 0
            analogWrite(a, 6, 0);
            analogWrite(a, 9, min(round(u / 2 * 255 / Vref_arduino), 255));
        else
            analogWrite(a, 9, 0);
            analogWrite(a, 6, min(round(-u / 2 * 255 / Vref_arduino), 255));
        end
        t = toc;
        counter = counter + 1;
        x1real = [x1real x1];
        x1guesses = [x1guesses x1obs];
        x2real = [x2real x2];
        x2guesses = [x2guesses x2obs];
        timeData = [timeData t];
        positionData = [positionData x1];
        velocityData = [velocityData x2];
        uData = [uData u];
    end
    analogWrite(a,6,0);
    analogWrite(a,9,0);
    figure(1);clf;
    subplot(3,1,1)
    plot(timeData, positionData);
    title('position')
    subplot(3,1,2)
    plot(timeData, velocityData);
    title('velocity')
    subplot(3,1,3)
    plot(timeData, uData);
    title('controller')
    figure(2)
    subplot(4,1,1)
    plot(timeData, x1real);
    title('x1')
    subplot(4,1,2)
    plot(timeData, x1guesses);
    title('x1 observer')
    subplot(4,1,3)
    plot(timeData, x2real);
    title('x2')
    subplot(4,1,4)
    plot(timeData, x2guesses);
    title('x2 observer')
end