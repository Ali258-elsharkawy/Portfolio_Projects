
# Customer Segmentation using K-Means Clustering

This project focuses on **customer segmentation** for an online retail business based in the UK. Using the **Online Retail II dataset**, the goal was to identify distinct customer groups based on their **recency, frequency**, and **monetary value** (RFM metrics), and suggest strategies for each group.

## Dataset

The dataset used in this project is the **Online Retail II** dataset, which contains all transactions occurring for a UK-based non-store online retail business between 01/12/2009 and 09/12/2011. The company mainly sells unique all-occasion gift-ware, and many of its customers are wholesalers.

For this project, I worked with the data from **01/12/2009 to 01/12/2010**.

### Dataset Link:
You can access the full dataset here: [Online Retail II Dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail+II)

## Project Overview

This project follows a structured process for **customer segmentation** to identify the most valuable customers and those who need re-engagement. Key tasks included:

### 1. Data Cleaning:
- Removed invalid entries.
- Filtered outliers and irrelevant transactions.
- Ensured data quality by addressing missing values and negative quantities.

### 2. Feature Engineering:
- **Recency**: Time since the customer last made a purchase.
- **Frequency**: Number of unique purchases made by the customer.
- **Monetary Value**: Total spending by the customer.

### 3. Clustering with K-Means:
- Applied **K-Means clustering** to segment customers based on the RFM metrics.
- Used the **elbow method** to determine the optimal number of clusters and validated it using the **silhouette score**.

### 4. Outlier Segmentation:
- Manually segmented outliers into three categories:
  - **Pamper**: High spenders, infrequent buyers.
  - **Upsell**: Frequent buyers with lower spending.
  - **Delight**: High spenders and frequent buyers.

### 5. Visualizations:
- Used histograms, boxplots, and 3D scatter plots to visualize customer distributions and clusters.

## Key Findings

After applying K-Means clustering and analyzing customer behavior, I identified the following segments:

- **"Reward"**: Loyal and frequent buyers.
- **"Retain"**: High-value but less frequent customers.
- **"Re-Engage"**: Infrequent customers who need re-engagement.
- **"Nurture"**: New or low-value customers who need nurturing.

### Outlier Segments:
- **Pamper**: High spenders but infrequent.
- **Upsell**: Frequent but low spenders.
- **Delight**: High spenders and frequent buyers.

## Requirements

To run the code, ensure you have the following Python libraries installed:

- `pandas`
- `numpy`
- `matplotlib`
- `seaborn`
- `scikit-learn`

You can install these using pip:

```bash
pip install pandas numpy matplotlib seaborn scikit-learn
```

## How to Use

1. Clone this repository.
2. Download the dataset and place it in the project folder.
3. Run the Jupyter notebook or Python script to perform the customer segmentation analysis.
4. Analyze the results and visualizations to derive insights.

## License

This project is licensed under the MIT License.
