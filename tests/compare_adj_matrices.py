import argparse
import numpy as np
import scipy.io as io
import sys


def main(args):
    '''
    Compare two sparse matrices stored in .mat files.
    Each .mat file is expected to have the sparse matrix stored in Adj_Matrix.
    Uses numpy.allclose to compare the data values using the default tolerance.
    Return with exit code 1 if the spare matrices are not equal.
    '''
    mat_contents1 = io.loadmat(args.mat_file[0])
    matrix1 = mat_contents1['Adj_Matrix']

    mat_contents2 = io.loadmat(args.mat_file[1])
    matrix2 = mat_contents2['Adj_Matrix']

    # Inspired by PyPardisoProject
    # https://github.com/haasad/PyPardisoProject/blob/f666ea4718b32fa1359e5ca94bedac710b09a428/pypardiso/pardiso_wrapper.py#L173
    if (np.array_equal(matrix1.indptr, matrix2.indptr) and
            np.array_equal(matrix1.indices, matrix2.indices) and
            np.allclose(matrix1.data, matrix2.data)):
        print('Spare matrices in {} and {} are equal'.format(args.mat_file[0],
              args.mat_file[1]))
    else:
        print('Spare matrices in {} and {} are not equal'.format(args.mat_file[0],
              args.mat_file[1]))
        sys.exit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Compare the Adj_Matrix '
        'sparse matrices in two .mat files. '
        'Return with exit code 1 if they are not equal.')
    parser.add_argument('mat_file', type=str, nargs=2,
                        help='The .mat files to compare. Exactly two required.')

    main(parser.parse_args())
