package com.rohith.fastgo;

import com.rohith.fastgo.util.DBConnection;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class FastGoServer {

    public static void main(String[] args) throws Exception {
        int port = 8081;
        if (args.length > 0) {
            try { port = Integer.parseInt(args[0]); } catch (Exception ignored) {}
        }

        System.out.println("=========================================================");
        System.out.println("   Starting FastGo Food Delivery Web Application Server   ");
        System.out.println("=========================================================");

        // Trigger DB initialization
        try {
            DBConnection.getConnection();
        } catch (Exception e) {
            System.err.println("Database initialization warning: " + e.getMessage());
        }

        String webappDirLocation = "src/main/webapp";
        File webappDir = new File(webappDirLocation);
        if (!webappDir.exists()) {
            webappDir.mkdirs();
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector();

        StandardContext ctx = (StandardContext) tomcat.addWebapp("", new File(webappDirLocation).getAbsolutePath());
        ctx.setParentClassLoader(FastGoServer.class.getClassLoader());
        
        File additionWebInfClasses = new File("target/classes");
        WebResourceRoot resources = new StandardRoot(ctx);
        resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                additionWebInfClasses.getAbsolutePath(), "/"));
        ctx.setResources(resources);

        System.out.println("FastGo Food Delivery application starting at:");
        System.out.println("👉 http://localhost:" + port);
        System.out.println("=========================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
