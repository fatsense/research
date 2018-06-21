#!/bin/bash

SEX=0		#'1' for men, '0' for women
AGE=0
WEIGHT=0.00	#KG
HEIGHT=0.00	#M

# Calculate Body mass index - BMI
# BMI = kg / m^2

BMI=$(awk "BEGIN {printf \"%.2f\n\", $WEIGHT/($HEIGHT*$HEIGHT)}")

echo "Body mass index (BMI): $BMI"

# Calculate Body fat - BF

## For children up to 15 years old:
## BF% = (1.51 * BMI) - (0.70 * age) - (3.6 * sex) + 1.4

## For adults:
## BF% = (1.20 * BMI) + (0.23 * age) - (10.8 * sex) - 5.4
if [ $AGE -le 15 ]; then
    BF=$(awk "BEGIN {printf \"%.4f\n\", ((1.51 * $BMI) - (0.70 * $AGE) - (3.6 * $SEX) + 1.4)/100}")
elif [ $AGE -gt 15 ]; then
	BF=$(awk "BEGIN {printf \"%.4f\n\", ((1.20 * $BMI) + (0.23 * $AGE) - (10.8 * $SEX) - 5.4)/100}")
else
    echo "EXIT_FAILURE: Not applicable age value."
    exit 1
fi

BF100=$(awk "BEGIN {printf \"%.2f\n\", $BF * 100}")
echo "Body fat % (BF): $BF100 %"

# Calculate Lean Muscle Mass - LBM
LBM=$(awk "BEGIN {printf \"%.2f\n\", ($WEIGHT * (100 - $BF)) / 100}")

echo "Lean Muscle Mass (LBM): $LBM"

# Calculate Basal Metabolic Rate (BMR)
## Mifflin St Jeor
## Formula:
## Men:   (10 * W) + (6.25 * H ) - (5 * A) + 5
## Women: (10 * W) + (6.25 * H ) - (5 * A) - 161
## Variables: W=weight in kilograms, H=height in centimeters, A=age in years
if [ $SEX -eq 0 ]; then
    MIFFLIN_ST_JEOR=$(awk "BEGIN {printf \"%.2f\n\", (10 * $WEIGHT) + (6.25 * ($HEIGHT * 100) ) - (5 * $AGE) - 161}")
elif [ $SEX -eq 1 ]; then
    MIFFLIN_ST_JEOR=$(awk "BEGIN {printf \"%.2f\n\", (10 * $WEIGHT) + (6.25 * ($HEIGHT * 100) ) - (5 * $AGE) + 5}")
else
    echo "EXIT_FAILURE: Not applicable sex value."
    exit 1
fi

echo "BMR with Mifflin St Jeor: $MIFFLIN_ST_JEOR"

## Katch-McArdle
### Formula:
### 370 + ( 21.6 * ( W * ( 1 - P ) ) )
### Variables: W=weight in kilograms, P=body fat percentage
KATCH_MCARDLE=$(awk "BEGIN {printf \"%.2f\n\", 370 + (21.6 * ($WEIGHT * (1 - $BF)))}")

echo "BMR with Katch-McArdle: $KATCH_MCARDLE"

## Katch-McArdle (Hybrid)
### Formula:
### (370 * ( 1 - P )) + (21.6 * (W * (1 - P))) + (6.17 * (W * P))
### Variables: W=weight in kilograms, P=body fat percentage
KATCH_MCARDLE_HYBRID=$(awk "BEGIN {printf \"%.2f\n\", (370 * (1 - $BF)) + (21.6 * ($WEIGHT * (1 - $BF))) + (6.17 * ($WEIGHT * $BF))}")

echo "BMR with Katch-McArdle (Hybrid): $KATCH_MCARDLE_HYBRID"

## Katch-McArdle (Wikipedia)
### P = 370 + ( 21.6 * LBM ), where LBM is the lean body mass in kg
KATCH_MCARDLE_WIKI=$(awk "BEGIN {printf \"%.2f\n\", 370 + (21.6 * $LBM)}")

echo "BMR with Katch-McArdle (Wikipedia): $KATCH_MCARDLE_WIKI"

## Cunningham
### Formula:
### 500 + ( 22 * ( W * ( 1 - P ) ) )
### Variables: W=weight in kilograms, P=body fat percentage
CUNNINGHAM=$(awk "BEGIN {printf \"%.2f\n\", 500 + (22 * ($WEIGHT * (1 - $BF)))}")

echo "BMR with Cunningham: $CUNNINGHAM"

