package kr.co.peterpet.util;

public class Page {
	int displayPageNum = 5;
	int displayPostNum = 7;
	private int totalPosts;
	private int currentPage;
	private int totalPages = 1;
	private int startPage = 1;
	private int endPage = 1;
	private int lastStartPage = 1;
	private int posts; // limit offset에서 offset담당

	public Page() {

	}

	public Page(int totalPosts, int currentPage) {
		this.totalPosts = totalPosts;
		this.currentPage = currentPage;
		if (totalPosts != 0) {
			totalPages = totalPosts / displayPostNum;
			if (totalPosts % displayPostNum > 0) {
				totalPages++;
			}

			lastStartPage = ((totalPages - 1) / 5) * 5 + 1;

			posts = (currentPage - 1) * displayPostNum; // limit offset에서 offset담당

			startPage = ((currentPage - 1) / 5) * 5 + 1;
			endPage = startPage + 4;
			if (endPage > totalPages)
				endPage = totalPages;
		}
	}

	public int getTotal() {
		return totalPosts;
	}

	public boolean hasNoSpaces() {
		return totalPosts == 0;
	}

	public boolean hasSpaces() {
		return totalPosts > 0;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public int getTotalPages() {
		return totalPages;
	}

	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public int getPosts() {
		return posts;
	}

	public void setPosts(int posts) {
		this.posts = posts;
	}

	public int getLastStartPage() {
		return lastStartPage;
	}

	public void setLastStartPage(int lastStartPage) {
		this.lastStartPage = lastStartPage;
	}
}
