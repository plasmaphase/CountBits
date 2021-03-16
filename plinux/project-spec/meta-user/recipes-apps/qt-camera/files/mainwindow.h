#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <opencv2/opencv.hpp>
#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <QTimer>
#include <QFileDialog>

using namespace cv;
using namespace std;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    //Mat转QLabel
    QImage MatImageToQt(const Mat &src);
    ~MainWindow();

private slots:
    void readFarme();
    void captureImage();
    void saveImage();
    void on_Open_triggered();
    void on_Stop_triggered();

private:
    Ui::MainWindow *ui;
    VideoCapture cap;
    Mat src_image;
    QTimer *timer;
    QImage *image;
};

#endif // MAINWINDOW_H
