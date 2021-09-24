import cv2
import matplotlib.pyplot as plt
import numpy as np

from sklearn.cluster import DBSCAN


def get_image(name):
    return cv2.imread(name)
    # Read picture


def Preprocess(img):
    img1 = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Convert picture to grayscale
    me_ima = cv2.medianBlur(img1, 7)
    me_ima = cv2.medianBlur(me_ima, 7)
    me_ima = cv2.GaussianBlur(me_ima, (3, 3), 0)
    mlist = me_ima.tolist()

    # Two median filtering (7x7 size)
    # and one Gaussian filtering (3x3 convolution kernel) are used to process the noise
    minc = [sorted(i)[1] for i in zip(*mlist)]
    minc = min(minc)
    # Find the darkest point (that is, the smallest number) in the new image
    img2, th2 = cv2.threshold(me_ima, minc + 15, 255, cv2.THRESH_BINARY)
    # Binarize the picture according to the darkest point that has been found

    img4 = cv2.Canny(th2, 0, 255)
    imgl = img4
    m = 40
    # Then perform edge detection based on the binarized image

    for i in range(1):
        points_list1 = cv2.HoughLinesP(imgl, 1, np.pi / 360, 20, \
                                       minLineLength=60, maxLineGap=40)
        if points_list1 is None:
            break
        if len(points_list1) > 0:
            points_list = points_list1.tolist()
            for point in points_list:
                cv2.line(th2, (point[0][0], point[0][1]), \
                         (point[0][2], point[0][3]), (255, 255, 255), 14)
        m = m + 100

    # Because image 2 has the interference of the black frame,
    # the Hough transform is used to find the straight line in the image
    # And eliminate these straight lines
    k = np.ones((3, 3), np.uint8)
    er1 = 0
    er = cv2.dilate(th2, k, er1, iterations=1)
    k = np.ones((4, 4), np.uint8)
    er = cv2.erode(er, k, er1, iterations=5)

    # Sometimes the straight line processing is not complete,
    # and some black spots are left,
    # so perform corrosion and dilation operations
    # to eliminate them (maybe not complete)
    return er


def Clustering(er):
    area1 = []
    area2 = []
    area3 = []
    area4 = []
    area = []
    lp = len(er)
    lp1 = len(er[0])
    for i in range(lp):
        for j in range(lp1):
            if er[i][j] == 0:
                area.append([j, i])
    area = np.array(area)
    # Scan the entire image and
    # record the coordinates of the black point
    clustering = DBSCAN(eps=1.0, min_samples=2).fit(area)
    labels = clustering.labels_
    labels = labels.tolist()
    maxc = max(labels)

    area = area.tolist()
    for l in range(len(labels)):
        if labels[l] == 0:
            area1.append(area[l])
        elif labels[l] == 1:
            area2.append(area[l])
        elif labels[l] == maxc - 1:
            area3.append(area[l])
        elif labels[l] == maxc:
            area4.append(area[l])
    # Using the DBSCAN clustering algorithm,
    # these points are divided into multiple classes,
    # (because the black dots are located on the outermost side,
    # so even if there are remaining noise points in the figure,
    # we only need to take the first two and the last two
    # to get 4 All coordinates of the black point)
    return area1, area2, area3, area4


def find_4point(area1, area2, area3, area4):
    c1x = [x for x, y in area1]
    c1y = [y for x, y in area1]
    c1 = (int(np.mean(c1x)), int(np.mean(c1y)))

    c2x = [x for x, y in area2]
    c2y = [y for x, y in area2]
    c2 = (int(np.mean(c2x)), int(np.mean(c2y)))

    c3x = [x for x, y in area3]
    c3y = [y for x, y in area3]
    c3 = (int(np.mean(c3x)), int(np.mean(c3y)))

    c4x = [x for x, y in area4]
    c4y = [y for x, y in area4]
    c4 = (int(np.mean(c4x)), int(np.mean(c4y)))

    sr = [c1, c2, c3, c4]

    # Then find these 4 regional centers

    sr.sort(key=lambda x: x[1])
    t1, t2 = sr[0], sr[1]
    d1, d2 = sr[2], sr[3]

    if t1[0] > t2[0]:
        t1, t2 = t2, t1
    if d1[0] > d2[0]:
        d1, d2 = d2, d1
    sor1 = [t1, t2, d1, d2]
    # We get that the top two points must be the top two points.
    # Of these two, the one on the left must be the top left point,
    # and the other must be the top right point.
    # The two points at the bottom can also be determined this way
    return sor1


def trans(img, sor1):
    sc = [(24, 24), (456, 24), (24, 456), (456, 456)]
    # This is the position of the 4 black dots determined
    # according to the original image
    point4 = np.ones((4, 2), dtype='float32')
    point4[0] = sc[0]
    point4[1] = sc[1]
    point4[2] = sc[2]
    point4[3] = sc[3]
    tpoint4 = np.ones((4, 2), dtype='float32')
    tpoint4[0] = sor1[0]
    tpoint4[1] = sor1[1]
    tpoint4[2] = sor1[2]
    tpoint4[3] = sor1[3]
    # Put these two sets of data into an array

    matu = cv2.getPerspectiveTransform(tpoint4, point4)
    img0 = cv2.warpPerspective(img, matu, (480, 480))
    # Then use getPerspectiveTransform and warpPerspective
    # to perform transmission transformation on the image
    # to change the image back to the original direction

    return img0


def output(img, img0, testpoint, pict):
    test = cv2.medianBlur(img0, 7)
    test = cv2.medianBlur(test, 7)
    test = cv2.GaussianBlur(test, (3, 3), 0)
    # Then deal with the noise on the color picture
    B_color = test[:, :, 0]
    G_color = test[:, :, 1]
    R_color = test[:, :, 2]
    # Then separate the three color channels of RGB
    color_mat = []
    for x, y in testpoint:
        B_testarea = np.mean(np.array([B_color[x + x1][y + y1] \
                                       for x1 in range(-5, 6) for y1 in range(-5, 6)]))
        G_testarea = np.mean(np.array([G_color[x + x1][y + y1] \
                                       for x1 in range(-5, 6) for y1 in range(-5, 6)]))
        R_testarea = np.mean(np.array([R_color[x + x1][y + y1] \
                                       for x1 in range(-5, 6) for y1 in range(-5, 6)]))
        # Then fix a test area (10x10)
        # according to the test points previously determined,
        # and then average each color (to prevent noise interference)
        if B_testarea > 200 and G_testarea > 200 \
                and R_testarea > 200:
            color_mat.append('w')
        elif G_testarea > 200 and R_testarea > 190:
            color_mat.append('y')
        elif G_testarea > 200:
            color_mat.append('g')
        elif B_testarea > 200:
            color_mat.append('b')
        elif R_testarea > 200:
            color_mat.append('r')
            # Determine the color according to the numerical value of the RGB color
    plt.figure(pict)
    plt.subplot(1, 2, 1)
    plt.imshow(img[:, :, ::-1])
    plt.title('Original')
    plt.subplot(1, 2, 2)
    plt.imshow(test[:, :, ::-1])
    plt.title('transformation')
    plt.show()
    for i in range(4):
        print(color_mat[i * 4:(i + 1) * 4])


#     print result

def main():
    testpoint = [108, 196, 284, 372]
    testpoint = [(y, x) for y in testpoint for x in testpoint]
    # These points are the center coordinates of each color block,
    # which are determined based on the origin image
    # testset=['IMAG0032.jpg','IMAG0033.jpg','IMAG0034.jpg','IMAG0035.jpg','IMAG0036.jpg','IMAG0037.jpg','IMAG0038.jpg','IMAG0041.jpg','IMAG0042.jpg','IMAG0044.jpg']
    testset = ['noise_1.png', 'noise_2.png', 'noise_3.png', 'noise_4.png', 'noise_5.png', \
               'org_1.png', 'org_2.png',
               'org_3.png', 'org_4.png', 'org_5.png' \
        , 'proj_1.png', 'proj_2.png', 'proj_3.png', 'proj_4.png', 'proj_5.png', \
               'proj1_1.png', 'proj1_2.png',
               'proj1_3.png', 'proj1_4.png', 'proj1_5.png', \
               'proj2_1.png', 'proj2_2.png', 'proj2_3.png', 'proj2_4.png', 'proj2_5.png ' \
        , 'rot_1.png', 'rot_2.png', 'rot_3.png', 'rot_4.png', 'rot_5.png']
    # # This is the image that will be read
    for pict in testset:
        img = get_image(pict)
        img0 = Preprocess(img)
        area = Clustering(img0)
        point = find_4point(area[0], area[1], area[2], area[3])
        img1 = trans(img, point)
        print(pict)
        output(img, img1, testpoint, pict)
        print()


main()
