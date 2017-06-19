/**
 * 此类用来辅助EasyUI分页
 */

package com.fh.entity;

import java.util.List;

import com.fh.util.PageData;

public class PageJson {

	
	private int page;	//当前页
	
	private List<PageData> rows = null;
	
	public List<PageData> getRows() {
		return rows;
	}
	public void setRows(List<PageData> listPage) {
		this.rows = listPage;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	
	
}
