package com.aurora.gplayapi.helpers.contracts

import com.aurora.gplayapi.data.models.StreamBundle
import com.aurora.gplayapi.data.models.StreamCluster
import com.aurora.gplayapi.helpers.contracts.StreamContract.Category

interface CategoryStreamContract {
    fun fetch(url: String): StreamBundle
    fun nextStreamCluster(nextPageUrl: String): StreamCluster
    fun nextStreamBundle(category: Category, nextPageToken: String): StreamBundle
}