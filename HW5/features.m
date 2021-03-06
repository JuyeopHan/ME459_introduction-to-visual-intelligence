clc; clear all; close all;

pts_a1 = [
    1842, 1167, 1; % 1
    1911, 1318, 1; % 2
    2432, 1496, 1; % 3
    2940, 1672, 1; % 4
    2234, 1581, 1; % 5
    2413, 1658, 1; % 6
    2898, 1849, 1; % 7
    1653, 1604, 1; % 8
    2175, 2018, 1; % 9
    2718, 2243, 1; % 10
    1338, 1951, 1; % 11
    1902, 2445, 1; % 12
    2495, 2735, 1; % 13
    1604, 2913, 1; % 14
    2250, 3280, 1; % 15
    1116, 2932, 1; % 16
    1008, 3283, 1; % 17
    1259, 3446, 1; % 18
    1603, 3661, 1; % 19
    1972, 3904, 1; % 20
    ];

pts_a2 = [
    309, 943, 1; % 1
    452, 1076, 1; % 2
    1036, 1077, 1; % 3
    1546, 1083, 1; % 4
    888, 1225, 1; % 5
    1085, 1236, 1; % 6
    1572, 1245, 1; % 7
    314, 1458, 1; % 8
    1023, 1664, 1; % 9
    1568, 1672, 1; % 10
    138, 1944, 1; % 11
    967, 2022, 1; % 12
    1564, 2026, 1; % 13
    850, 2730, 1; % 14
    1555, 2734, 1; % 15
    374, 2992, 1; % 16
    421, 3367, 1; % 17
    745, 3370, 1; % 18
    1149, 3366, 1; % 19
    1547, 3369, 1; % 20
    ];

pts_b1 = [
    2592, 1572, 1; % 1
    2427, 1682, 1; % 2
    1174, 1840, 1; % 3
    1415, 2065, 1; % 4
    1990, 2038, 1; % 5
    1022, 2254, 1; % 6
    1258, 2256, 1; % 7
    1681, 2396, 1; % 8
    2634, 2535, 1; % 9
    1794, 2743, 1; % 10
    2022, 2845, 1; % 11
    2645, 2883, 1; % 12
    1058, 2933, 1; % 13
    1374, 2942, 1; % 14
    1565, 2957, 1; % 15
    2029, 3037, 1; % 16
    2656, 3113, 1; % 17
    1056, 3486, 1; % 18
    1664, 3384, 1; % 19
    2006, 3317, 1; % 20
    ];


pts_b2 = [
    1892, 1596, 1; % 1
    1736, 1692, 1; % 2
    445, 1806, 1; % 3
    710, 2050, 1; % 4
    1322, 2026, 1; % 5
    268, 2248, 1; % 6
    534, 2252, 1; % 7
    995, 2392, 1; % 8
    1914, 2503, 1; % 9
    1105, 2741, 1; % 10
    1332, 2830, 1; % 11
    1922, 2836, 1; % 12
    308, 2970, 1; % 13
    659, 2960, 1; % 14
    862, 2965, 1; % 15
    1336, 3018, 1; % 16
    1928, 3055, 1; % 17
    298, 3562, 1; % 18
    965, 3392, 1; % 19
    1315, 3298, 1; % 20
    ];

pts_c1 = [
    1481, 1690, 1; % 1
    1865, 1470, 1; % 2
    2095, 1335, 1; % 3
    2657, 1020, 1; % 4
    1457, 2296, 1; % 5
    1881, 2135, 1; % 6
    2132, 2043, 1; % 7
    2789, 1791, 1; % 8
    1410, 2903, 1; % 9
    1884, 2803, 1; % 10
    2167, 2755, 1; % 11
    2920, 2605, 1; % 12
    1622, 3135, 1; % 13
    1889, 3104, 1; % 14
    2180, 3070, 1; % 15
    2545, 3026, 1; % 16
    1612, 3364, 1; % 17
    1889, 3350, 1; % 18
    2190, 3335, 1; % 19
    2571, 3315, 1; % 20
    ];

pts_c2 = [
    260, 1341, 1; % 1
    851, 1322, 1; % 2
    1148, 1314, 1; % 3
    1737, 1297, 1; % 4
    205, 2050, 1; % 5
    865, 2027, 1; % 6
    1178, 2019, 1; % 7
    1826, 1997, 1; % 8
    76, 2726, 1; % 9
    804, 2703, 1; % 10
    1148, 2693, 1; % 11
    1875, 2668, 1; % 12
    402, 3009, 1; % 13
    780, 2998, 1; % 14
    1137, 2987, 1; % 15
    1517, 2974, 1; % 16
    367, 3253, 1; % 17
    762, 3241, 1; % 18
    1128, 3230, 1; % 19
    1520, 3220, 1; % 20
    ];

save('features.mat');