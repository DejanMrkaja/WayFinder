#include "listmodel.h"
#include <QDebug>
/*********************** CListModel *****************************/
CListModel::CListModel()
{

}

CListModel::~CListModel()
{

}

void CListModel::addData(const QString &unit, const QString &unit2)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_names.append(unit);
    category.append(unit2);

    endInsertRows();
}

void CListModel::clear()
{
    m_names.clear();
    category.clear();
}

int CListModel:: rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_names.count();
}

QVariant CListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_names.count())
        return QVariant();

    const QString &name = m_names[index.row()];
    if (role == NameRole)
        return name;
    else if(role==CatRole)
        return category[index.row()];

    return QVariant();
}

QHash<int, QByteArray> CListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[CatRole]="category";



    return roles;
}
/*********************** CListModel *****************************/


/******************** FilterProxyModel **************************/
FilterProxyModel::FilterProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    setSortOrder(false);
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
}

FilterProxyModel::~FilterProxyModel()
{

}

void FilterProxyModel::setFilterString(QString string)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
   // this->setFilterFixedString(string);
    m_filter_string = string;
    invalidateFilter();
}

void FilterProxyModel::setFilterCategory(QString string_cat)
{
    this->setFilterCaseSensitivity(Qt::CaseInsensitive);
    m_filter_category=string_cat;
    invalidateFilter();
}

void FilterProxyModel::setFilterRole(Roles role)
{
    m_role = role;
}

void FilterProxyModel::setSortOrder(bool checked)
{
    if(checked)
    {
        this->sort(0, Qt::DescendingOrder);
    }
    else
    {
        this->sort(0, Qt::AscendingOrder);
    }
}

bool FilterProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{

    QModelIndex ind = sourceModel()->index(source_row, 0, source_parent);

    QString name = sourceModel()->data(ind, NameRole).toString();
    QString cat = sourceModel()->data(ind, CatRole).toString();


    bool b = name.contains(m_filter_string,Qt::CaseSensitivity(0));
    bool a =cat.contains(m_filter_category);

    return a&&b;
}
/******************** FilterProxyModel **************************/
