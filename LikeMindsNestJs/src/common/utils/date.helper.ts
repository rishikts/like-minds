/**
 * Date and time utilities
 */

export class DateHelper {
  static now(): Date {
    return new Date();
  }

  static addMinutes(date: Date, minutes: number): Date {
    return new Date(date.getTime() + minutes * 60000);
  }

  static addHours(date: Date, hours: number): Date {
    return new Date(date.getTime() + hours * 3600000);
  }

  static addDays(date: Date, days: number): Date {
    return new Date(date.getTime() + days * 86400000);
  }

  static isInThePast(date: Date): boolean {
    return date < this.now();
  }

  static isInTheFuture(date: Date): boolean {
    return date > this.now();
  }

  static getDifferenceInMinutes(date1: Date, date2: Date): number {
    return Math.floor((date2.getTime() - date1.getTime()) / 60000);
  }

  static getDifferenceInHours(date1: Date, date2: Date): number {
    return Math.floor((date2.getTime() - date1.getTime()) / 3600000);
  }
}
