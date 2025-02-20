"""X"""
import numpy as np
import matplotlib.pyplot as plt


def _generate_samples(mean, std_dev, num_samples, lower_bound, upper_bound):
    samples = []
    while len(samples) < num_samples:
        sample = np.random.normal(mean, std_dev)
        if lower_bound <= sample <= upper_bound:
            samples.append(sample)
    return np.array(samples)


def _save_samples_to_text_file(samples, file_path):
    np.savetxt(file_path, samples, fmt="%f")


def _save_samples_to_scad_file(samples, file_path):
    data = ", ".join(map(str, samples))
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(f"data = [{data}];\n")


# Generate bounded samples
bounded_samples = _generate_samples(
    mean=7,
    std_dev=3.8,
    num_samples=300,
    lower_bound=0,
    upper_bound=14,
)

# _save_samples_to_text_file(
#     bounded_samples,
#     "/home/saeed/code/3d_models/galton_board/normal_distribution_samples.txt",
# )
_save_samples_to_scad_file(
    bounded_samples,
    "/home/saeed/code/3d_models/galton_board/normal_distribution_samples.scad",
)


# Plotting the distribution
n_bins = int(140 // 3.2)
plt.hist(bounded_samples, bins=n_bins, density=False, alpha=0.6, color="g")

# Plot aesthetics
plt.title("Histogram of Normal Distribution Samples")
plt.xlabel("Value")
plt.ylabel("Density")
plt.axis("equal")

# Show the plot
plt.show()
