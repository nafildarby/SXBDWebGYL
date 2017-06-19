package com.fh.service.system;

import com.fh.entity.Page;
import com.fh.util.PageData;

import java.util.List;

/**
 * Created by Pulifan on 2017/4/1.
 */
public interface IService {

    List<PageData> listAskforPage(Page page) throws Exception;
}
