package com.guran.gametracker;

/**
 * Created by goranpaues on 2017-04-23.
 */
public class PlatformChart {
    private String platform;
    private long numberOfGames;

    public PlatformChart(String platform, long numberOfGames) {
        this.platform = platform;
        this.numberOfGames = numberOfGames;
    }

    @Override
    public String toString() {
        return String.format(
                "PlatformChart[platform='%s', numberOfGames=%d]",
                platform, numberOfGames);
    }

    // getters & setters omitted for brevity
}
