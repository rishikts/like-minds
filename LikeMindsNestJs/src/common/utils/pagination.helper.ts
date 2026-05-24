/**
 * Pagination utilities
 */

export interface PaginationParams {
  page?: number;
  limit?: number;
}

export class PaginationHelper {
  static DEFAULT_PAGE = 1;
  static DEFAULT_LIMIT = 20;
  static MAX_LIMIT = 100;

  static parse(page?: number, limit?: number) {
    const parsedPage = Math.max(1, page || this.DEFAULT_PAGE);
    const parsedLimit = Math.min(limit || this.DEFAULT_LIMIT, this.MAX_LIMIT);

    return {
      page: parsedPage,
      limit: parsedLimit,
      skip: (parsedPage - 1) * parsedLimit,
    };
  }

  static getMeta(total: number, page: number, limit: number) {
    const totalPages = Math.ceil(total / limit);
    return {
      total,
      page,
      limit,
      totalPages,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    };
  }
}
