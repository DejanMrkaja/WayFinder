#ifndef CLISTMODEL_H
#define CLISTMODEL_H

#include <QAbstractListModel>
#include <QSortFilterProxyModel>

enum Roles {
    NameRole = Qt::UserRole + 1,
    CatRole
};

//List Model
class CListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    CListModel();
    ~CListModel();

   Q_INVOKABLE void addData(const QString &unit, const QString &unit2);
     Q_INVOKABLE void clear();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QStringList m_names;
    QStringList category;
};


//Filter proxy model
class FilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:

    FilterProxyModel(QObject* parent = 0);

    ~FilterProxyModel();

    Q_INVOKABLE void setFilterString(QString string);
    Q_INVOKABLE void setFilterCategory(QString string_cat);

    Q_INVOKABLE void setFilterRole(Roles role);

    Q_INVOKABLE void setSortOrder(bool checked);

    Roles m_role;

    QString m_filter_string;
    QString m_filter_category;


protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const;

};


#endif // CLISTMODEL_H
