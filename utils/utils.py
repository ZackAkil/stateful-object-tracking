
import numpy as np

from scipy.ndimage import binary_dilation

import matplotlib.pyplot as plt


def expand_islands(matrix, n=0):
    # Create a structuring element for dilation
    structure = np.ones((3, 3), dtype=int)

    # Perform binary dilation on the matrix
    dilated_matrix = binary_dilation(matrix, iterations=n)

    return dilated_matrix


from scipy.ndimage import label, sum

def remove_small_islands(matrix, n=100):
    labeled_matrix, num_features = label(matrix)  # Label connected components
    component_sizes = sum(matrix, labeled_matrix, range(num_features + 1))  # Calculate sizes

    # Create a mask to filter out small islands
    # print(component_sizes)
    mask = (component_sizes >= n)

    # Apply the mask to remove small islands
    filtered_matrix = mask[labeled_matrix]

    return filtered_matrix


from scipy.ndimage import label

def find_islands(matrix):

  height, width, _ = matrix.shape

  # Apply the label function to find connected components
  labeled_matrix, num_labels = label(matrix)

  # Get the unique labels
  unique_labels = np.unique(labeled_matrix)

  boxes = []
  # Iterate over the unique labels (excluding background label 0)
  for label_value in unique_labels[1:]:
      # Create a mask for the current label
      mask = (labeled_matrix == label_value)

      # Find the indices of the ones in the mask
      indices = np.where(mask)

      avg_y = float(indices[0].mean()/height)
      avg_x = float(indices[1].mean()/width)

      min_x = int(indices[1].min()/width)
      max_x = int(indices[1].max()/width)

      min_y = int(indices[0].min()/height)
      max_y = int(indices[0].max()/height)

      box = {'pos':{'x':avg_x, 'y':avg_y}, 'bbox':{'min_x':min_x, 'max_x':max_x,
                                                   'min_y':min_y, 'max_y':max_y}}
      boxes.append(box)

  return boxes

def run_box_huristic(mask, threshold = 0.5):

  porlarized_matrix = mask > threshold

  expanded_pixels = expand_islands(porlarized_matrix, 1)

  removed_small_islands = remove_small_islands(expanded_pixels, n=50)

  boxes = find_islands(removed_small_islands)

  return boxes




def plot_boxes(image, bboxes, save=None):

  # plt.imshow(labeled_matrix)
  plt.clf()
  plt.imshow(image)

  height, width, _ = image.shape

  # Set the plot aspect ratio to equal
  plt.gca().set_aspect('equal')

  # Iterate over the unique labels (excluding background label 0)
  for box in bboxes:

      avg_y = box['pos']['y'] * height
      avg_x = box['pos']['x'] * width

      min_x = box['bbox']['min_x'] * width
      max_x = box['bbox']['max_x'] * width

      min_y = box['bbox']['min_y'] * height
      max_y = box['bbox']['max_y'] * height

      x, y = avg_x, avg_y
      circle = plt.Circle((x, y), radius=2, color='red', fill=True)

      rect = plt.Rectangle((min_x, min_y), max_x - min_x, max_y - min_y,
                         linewidth=1, edgecolor='r', facecolor='none')
      plt.gca().add_patch(circle)
      plt.gca().add_patch(rect)
      plt.axis('off')
  if save:
    plt.savefig(f'{save}.png', bbox_inches='tight', pad_inches=0)
  else:
    plt.show()
