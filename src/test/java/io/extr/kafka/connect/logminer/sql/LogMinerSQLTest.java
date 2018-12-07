package io.extr.kafka.connect.logminer.sql;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.junit.Assert;
import org.junit.Test;

import io.extr.kafka.connect.logminer.sql.LogMinerSQL.Statement;
import io.extr.kafka.connect.logminer.sql.LogMinerSQLFactory.Strategy;

public class LogMinerSQLTest {
	private static final LogMinerSQL MSQL = LogMinerSQLFactory.getInstance(Strategy.MULTITENANT);
	private static final LogMinerSQL SSQL = LogMinerSQLFactory.getInstance(Strategy.SINGLE_INSTANCE);

	@Test
	public void testMultitenantSQL() throws Exception {
		String statement = MSQL.getStatement(Statement.DICTIONARY);
		Assert.assertEquals("SQL does not match", getFileContents("sql/cdb_dictionary.sql"), statement);
		statement = MSQL.getStatement(Statement.CONTENTS);
		Assert.assertEquals("SQL does not match", getFileContents("sql/cdb_contents.sql"), statement);
		statement = MSQL.getStatement(Statement.START_MINING);
		Assert.assertEquals("SQL does not match", getFileContents("sql/start_mining.sql"), statement);
		statement = MSQL.getStatement(Statement.STOP_MINING);
		Assert.assertEquals("SQL does not match", getFileContents("sql/stop_mining.sql"), statement);
		statement = MSQL.getStatement(Statement.CURRENT_SCN);
		Assert.assertEquals("SQL does not match", getFileContents("sql/current_scn.sql"), statement);
		statement = MSQL.getStatement(Statement.LATEST_SCN);
		Assert.assertEquals("SQL does not match", getFileContents("sql/latest_scn.sql"), statement);
	}

	@Test
	public void testSingleInstanceSQL() throws Exception {
		String statement = SSQL.getStatement(Statement.DICTIONARY);
		Assert.assertEquals("SQL does not match", getFileContents("sql/dictionary.sql"), statement);
		statement = SSQL.getStatement(Statement.CONTENTS);
		Assert.assertEquals("SQL does not match", getFileContents("sql/contents.sql"), statement);
		statement = SSQL.getStatement(Statement.START_MINING);
		Assert.assertEquals("SQL does not match", getFileContents("sql/start_mining.sql"), statement);
		statement = SSQL.getStatement(Statement.STOP_MINING);
		Assert.assertEquals("SQL does not match", getFileContents("sql/stop_mining.sql"), statement);
		statement = SSQL.getStatement(Statement.CURRENT_SCN);
		Assert.assertEquals("SQL does not match", getFileContents("sql/current_scn.sql"), statement);
		statement = SSQL.getStatement(Statement.LATEST_SCN);
		Assert.assertEquals("SQL does not match", getFileContents("sql/latest_scn.sql"), statement);
	}

	private String getFileContents(String filePath) throws IOException, URISyntaxException {
		byte[] encoded = Files.readAllBytes(Paths.get(ClassLoader.getSystemResource(filePath).toURI()));
		return new String(encoded, Charset.forName("UTF8"));
	}
}