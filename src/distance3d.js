// helper function to calculate distance between two points in 3D space
export default function distance3d(p1, p2) {
  return Math.sqrt(
    Math.pow(p1[0] - p2[0], 2) +
      Math.pow(p1[1] - p2[1], 2) +
      Math.pow(p1[2] - p2[2], 2)
  );
}
