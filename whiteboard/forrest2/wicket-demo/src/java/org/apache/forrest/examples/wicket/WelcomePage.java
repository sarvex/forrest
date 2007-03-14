package org.apache.forrest.examples.wicket;

public class WelcomePage extends AuthenticatedWebPage {
	
	public WelcomePage() {
		super();
		String path = this.getRequest().getPath();
		/*
		 * When running in the WicketBench (Eclipse IDE Plugin) the test
		 * environment mounts the application at "/home". We'll stip this
		 * from the path. Note that this could cause a problem in production
		 * applications if they use a "/home*" URLspace.
		 * 
		 * We need to make the mount point of a WicketBench test configurable.
		 */
		if (path.startsWith("/home")) {
			path = path.substring(5);
		}
		// FIXME: the default page request should be configured elsewhere (e.g. web.xml)
		if (path.length() == 0 || path.equals("/")) {
			path = "/index.html";
		}
		new Forrest2Panel(this, "body", "body" + path);
	}
}