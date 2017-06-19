package com.fh.service.Warehouse;

import java.util.List;

import org.springframework.stereotype.Service;

import com.fh.entity.Page;
import com.fh.service.BaseService;
import com.fh.util.PageData;

@Service("StockService")
public class StockService extends BaseService {

	public List<PageData> StocklistPage(Page page) throws Exception {
		return listPageInfo(page,"StockXMapper.StocklistPage");
	}

}
