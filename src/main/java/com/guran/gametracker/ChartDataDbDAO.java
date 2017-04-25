package com.guran.gametracker;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by goranpaues on 2017-04-25.
 */
public class ChartDataDbDAO implements ChartDataDAO{

    private final Connection conn = DBConnection.getInstance().getConnection();


    public List<ChartData> query(String sqlQueryStr) {
        List<ChartData> resultList = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sqlQueryStr)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                resultList.add(
                        new ChartData(rs.getString("label"), rs.getString("value")));
            }
        } catch (SQLException e) {
            System.out.println("SQL Query Error: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Query Error: " + e.getMessage());
        }
        return resultList;
    }

    @Override
    public List<ChartData> getPlatformChart(){
        String queryStr = "select p.name as label, count(*) as value from\n" +
                                "platforms p\n" +
                                "join platform_list pl on pl.platform_id = p.id\n" +
                                "join games g on g.id = pl.game_id\n" +
                                "where p.name not in ('Linux','Mac','iPhone')\n" +
                                "and pl.game_id not in (select game_id \n" +
                                "                         from shelf_list sl\n" +
                                "                         join shelves s on s.id = sl.shelf_id\n" +
                                "                         where s.name = 'Backlog')\n" +
                                "group by p.name\n" +
                                "having count(*) > 10\n" +
                                "order by count(*)";
        List<ChartData> resultList = this.query(queryStr);
        return resultList;
    }


    @Override
    public List<ChartData> getLastYearChart(){
        String queryStr = "select \n" +
                                "to_char(trunc(date_added,'MONTH'),'yyyymm') label, \n" +
                                "nvl(count(1),0) value \n" +
                                "from games g\n" +
                                "join shelf_list sl on sl.game_id = g.id\n" +
                                "join shelves s on s.id = sl.shelf_id\n" +
                                "where s.name = 'Played'\n" +
                                "and sl.date_added > trunc(sysdate,'MONTH')-365\n" +
                                "group by trunc(date_added,'MONTH') \n" +
                                "order by label";
        List<ChartData> resultList = this.query(queryStr);
        return resultList;
    }

}
