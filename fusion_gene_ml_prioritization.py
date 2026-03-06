"""
Fusion Gene ML Prioritization
Author: Hiba Hashmi

This script applies a machine learning model to prioritize
high-confidence fusion gene candidates detected from RNA-seq
analysis using Arriba.
"""

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, roc_auc_score


# Load fusion results
data = pd.read_csv("results/fusions/fusions.tsv", sep="\t")

# Select example features
features = data[[
    "split_reads1",
    "split_reads2",
    "discordant_mates"
]]

# Example label column
data["label"] = data["confidence"].apply(
    lambda x: 1 if x == "high" else 0
)

X = features
y = data["label"]

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train model
model = RandomForestClassifier(n_estimators=200)
model.fit(X_train, y_train)

# Predictions
preds = model.predict(X_test)
probs = model.predict_proba(X_test)[:,1]

print("Model Evaluation:")
print(classification_report(y_test, preds))
print("ROC AUC:", roc_auc_score(y_test, probs))