clc; clear all; close all;

%% 1. load image
hutme = imread('hutme.jpg');
image(hutme)

%% 2. find parallel lines and their points

% point of parallel lines on image planes
pt_person_xS = [328, 328];
pt_person_yS = [603, 392];

pt_column1_xS = [400, 400];
pt_column1_yS = [645, 355];

pt_column2_xS = [128, 128];
pt_column2_yS = [536, 378];

pt_roof_xS = [pt_column1_xS(2), pt_column2_xS(2)];
pt_roof_yS = [pt_column1_yS(2), pt_column2_yS(2)];

pt_floor_xS = [pt_column1_xS(1), pt_column2_xS(1)];
pt_floor_yS = [pt_column1_yS(1), pt_column2_yS(1)];

pt_wall1_xS = [550, 848];
pt_wall1_yS = [636, 603];

pt_wall2_xS = [554, 765];
pt_wall2_yS = [239, 265];

% point of parallel lines on homogeneous coordinates
pt_person_top = [pt_person_xS(2), pt_person_yS(2), 1];
pt_person_bottom = [pt_person_xS(1), pt_person_yS(1), 1];

pt_column11 = [pt_column1_xS(1), pt_column1_yS(1), 1];
pt_column12 = [pt_column1_xS(2), pt_column1_yS(2), 1];

pt_roof1 = [pt_roof_xS(1), pt_roof_yS(1), 1];
pt_roof2 = [pt_roof_xS(2), pt_roof_yS(2), 1];

pt_floor1 = [pt_floor_xS(1), pt_floor_yS(1), 1];
pt_floor2 = [pt_floor_xS(2), pt_floor_yS(2), 1];

pt_wall11 = [pt_wall1_xS(1), pt_wall1_yS(1), 1];
pt_wall12 = [pt_wall1_xS(2), pt_wall1_yS(2), 1];

pt_wall21 = [pt_wall2_xS(1), pt_wall2_yS(1), 1];
pt_wall22 = [pt_wall2_xS(2), pt_wall2_yS(2), 1];

%% 2-1. show parallel lines
hold on;

plot(pt_person_xS, pt_person_yS, 'Color', 'r', 'LineWidth', 2)
plot(pt_column1_xS, pt_column1_yS, 'Color', 'm', 'LineWidth', 2)
plot(pt_column2_xS, pt_column2_yS, 'Color', 'm', 'LineWidth', 2)
plot(pt_roof_xS, pt_roof_yS, 'Color', 'b', 'LineWidth', 2)
plot(pt_floor_xS, pt_floor_yS, 'Color', 'b', 'LineWidth', 2)
plot(pt_wall1_xS, pt_wall1_yS, 'Color', 'g', 'LineWidth', 2)
plot(pt_wall2_xS, pt_wall2_yS, 'Color', 'g', 'LineWidth', 2)

%%  3. calculating vanishing points and a vanishing line

% line vectors
line_roof = cross(pt_roof1, pt_roof2);
line_floor = cross(pt_floor1, pt_floor2);

line_wall1 = cross(pt_wall11, pt_wall12);
line_wall2 = cross(pt_wall21, pt_wall22);

% vanishing points
vanish_pt_1 = cross(line_roof, line_floor);
vanish_pt_1 = vanish_pt_1/vanish_pt_1(3);

vanish_pt_2 = cross(line_wall1, line_wall2);
vanish_pt_2 = vanish_pt_2/vanish_pt_2(3);

% vanishing line
vanish_line = cross(vanish_pt_1, vanish_pt_2);

%% 4. calculating man's height

line_bottom = cross(pt_column11, pt_person_bottom);

% vanishing point between person and column 1
vanish_pt_prsn = cross(line_bottom, vanish_line);
vanish_pt_prsn = vanish_pt_prsn/ vanish_pt_prsn(3);

line_column1 = cross(pt_column11, pt_column12);
line_top = cross(vanish_pt_prsn, pt_person_top);

% correspoding point of height of person
pt_intsctn = cross(line_top, line_column1);
pt_intsctn = pt_intsctn / pt_intsctn(3);

% cross ratio computation
column_height = 201; % (cm)
man_height = column_height * abs(pt_intsctn(2) - pt_column1_yS(1))/ abs(pt_column1_yS(1) - pt_column1_yS(2)) % (cm)

plot([vanish_pt_1(1), vanish_pt_2(1)], [vanish_pt_1(2), vanish_pt_2(2)], 'Color', 'k', 'LineWidth', 2)
plot([pt_intsctn(1), vanish_pt_prsn(1)],[pt_intsctn(2), vanish_pt_prsn(2)], 'Color', 'y', 'LineWidth', 2)
plot([pt_column11(1), vanish_pt_prsn(1)], [pt_column11(2), vanish_pt_prsn(2)], 'Color', 'y', 'LineWidth', 2)
