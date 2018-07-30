#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QWindow>

#include <QObject>
#include <QQmlContext>



#include "listmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);



    CListModel listModel;


    FilterProxyModel filterModel;
    filterModel.setFilterCaseSensitivity(Qt::CaseInsensitive);
    filterModel.setSourceModel(&listModel);
    filterModel.setFilterRole(NameRole);
    filterModel.setSortRole(NameRole);


    QQmlApplicationEngine engine;
    QQmlContext* context = engine.rootContext();
    context->setContextProperty("filterModel", &filterModel);
    context->setContextProperty("listModel", &listModel);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}
