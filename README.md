# zoom

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
#   z o o m - t e s t 



Q1
	a.

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class InnerJoin {

    


    // Reducer class for performing the reduce task
    public static class InnerJoinReducer extends Reducer<Text, Text, Text, Text> {

        private Text outputValue = new Text(); // Value to emit for each joined record

        // Reduce function to process the records with the same key
        public void reduce(Text key, Iterable<Text> values, Context context)
                throws IOException, InterruptedException {

            // Separate the rows from different tables
            List<String> tableT1 = new ArrayList<>(); // Records from table T1
            List<String> tableT2 = new ArrayList<>(); // Records from table T2

            // Iterate through the values corresponding to the same key
            for (Text value : values) {
                String[] columns = value.toString().split(",");
                String tableName = columns[0]; // Table name from the input record
                String attributeValue = columns[1]; // Attribute value from the input record

                // Populate the lists based on the table name
                if (tableName.equals("T1")) {
                    tableT1.add(attributeValue);
                } else if (tableName.equals("T2")) {
                    tableT2.add(attributeValue);
                }
            }

            // Perform the join operation for each combination of records from T1 and T2
            for (String attributeT1 : tableT1) {
                for (String attributeT2 : tableT2) {
                    // Create the joined record
                    String joinedRow = "(" + key.toString() + "," + attributeT1 + "," + attributeT2 + ")";
                    outputValue.set(joinedRow);
                    context.write(null, outputValue); // Emit the joined record
                }
            }
        }
    }

    // Main method to configure and run the MapReduce job
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Inner Join");

        // Set the main class and mapper and reducer classes
        job.setJarByClass(InnerJoin.class);
        job.setMapperClass(InnerJoinMapper.class);
        job.setReducerClass(InnerJoinReducer.class);

        // Set output key and value classes
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        // Set input and output paths
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        // Exit the job after completion
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
__________________________________________________________________________________________

	b.

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class FullOuterJoin {

    public static class FullOuterJoinMapper extends Mapper<Object, Text, Text, Text> {

        private Text joinKey = new Text();
        private Text record = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String[] columns = value.toString().split(",");

            // Extract the table name, PK, and attribute value
            String tableName = columns[0];
            String primaryKey = columns[1];
            String attributeValue = columns[2];

            // Emit key-value pairs with the primary key as the key and the entire record as the value
            joinKey.set(primaryKey);
            record.set(tableName + "," + attributeValue);
            context.write(joinKey, record);
        }
    }

    public static class FullOuterJoinReducer extends Reducer<Text, Text, Text, Text> {

        private Text outputValue = new Text();

        public void reduce(Text key, Iterable<Text> values, Context context)
                throws IOException, InterruptedException {

            // Separate the rows from different tables
            List<String> tableT1 = new ArrayList<>();
            List<String> tableT2 = new ArrayList<>();

            for (Text value : values) {
                String[] columns = value.toString().split(",");
                String tableName = columns[0];
                String attributeValue = columns[1];

                // Populate the lists based on the table name
                if (tableName.equals("T1")) {
                    tableT1.add(attributeValue);
                } else if (tableName.equals("T2")) {
                    tableT2.add(attributeValue);
                }
            }

            // Perform the full outer join operation
            if (tableT1.isEmpty()) {
                for (String attributeT2 : tableT2) {
                    String joinedRow = "(null," + key.toString() + "," + attributeT2 + ")";
                    outputValue.set(joinedRow);
                    context.write(null, outputValue);
                }
            } else if (tableT2.isEmpty()) {
                for (String attributeT1 : tableT1) {
                    String joinedRow = "(" + key.toString() + "," + attributeT1 + ",null)";
                    outputValue.set(joinedRow);
                    context.write(null, outputValue);
                }
            } else {
                for (String attributeT1 : tableT1) {
                    for (String attributeT2 : tableT2) {
                        String joinedRow = "(" + key.toString() + "," + attributeT1 + "," + attributeT2 + ")";
                        outputValue.set(joinedRow);
                        context.write(null, outputValue);
                    }
                }
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Full Outer Join");
        job.setJarByClass(FullOuterJoin.class);
        job.setMapperClass(FullOuterJoinMapper.class);
        job.setReducerClass(FullOuterJoinReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}

_______________________________________________________________________________________

	c.

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class AttributeDifference {

    public static class DifferenceMapper extends Mapper<Object, Text, Text, NullWritable> {

        private Text attributeValue = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String[] columns = value.toString().split(",");

            // Extract the attribute value
            String attributeName = columns[0];
            String attribute = columns[1];

            // Emit the attribute value with table name as the key
            attributeValue.set(attributeName + "," + attribute);
            context.write(attributeValue, NullWritable.get());
        }
    }

    public static class DifferenceReducer extends Reducer<Text, NullWritable, IntWritable, NullWritable> {

        public void reduce(Text key, Iterable<NullWritable> values, Context context)
                throws IOException, InterruptedException {

            int tableNameCount = 0;
            for (NullWritable value : values) {
                tableNameCount++;
            }

            // If the attribute exists in T1 but not in T2, emit the attribute value
            if (tableNameCount == 1) {
                String[] attributeInfo = key.toString().split(",");
                int attributeValue = Integer.parseInt(attributeInfo[1]);
                context.write(new IntWritable(attributeValue), NullWritable.get());
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Attribute Difference");
        job.setJarByClass(AttributeDifference.class);
        job.setMapperClass(DifferenceMapper.class);
        job.setReducerClass(DifferenceReducer.class);
        job.setOutputKeyClass(IntWritable.class);
        job.setOutputValueClass(NullWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}

 
 
